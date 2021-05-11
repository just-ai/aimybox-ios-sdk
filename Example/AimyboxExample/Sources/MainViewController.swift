import Aimybox
import AVFoundation

// swiftlint:disable file_length

final
class MainViewController: UIViewController {

    private
    enum SoundType: String {
        case `in` = "sound_in"
        case `out` = "sound_out"

        var url: URL {
            guard let url = Bundle.main.url(forResource: rawValue, withExtension: "wav") else {
                fatalError()
            }
            return url
        }

    }

    private
    var aimybox: Aimybox?

    private
    var player: AVPlayer?

    private
    var rows: [Reply] = [] {
        didSet {
            tableView.reloadData()
            scrollToBottomIfNeeded()
        }
    }

    private
    lazy var loaderView = UIActivityIndicatorView().with {
        $0.hidesWhenStopped = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            $0.style = .medium
        } else {
            $0.style = .gray
        }
    }

    private
    lazy var tableView = UITableView().with {
        $0.dataSource = self
        $0.estimatedRowHeight = UIScreen.main.bounds.height
        $0.keyboardDismissMode = .onDrag
        $0.registerCell(of: ChatCell.self)
        $0.registerCell(of: DefaultCell.self)
        $0.registerCell(of: ExchangeRateCell.self)
        $0.registerCell(of: StockMarketCell.self)
        $0.registerCell(of: WeatherCell.self)
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorColor = .clear
        $0.separatorStyle = .none
        $0.tableFooterView = UIView()
    }

    private
    var isChatModeEnabled = false // lifehack for stop listening after chat

    private
    lazy var bottomMenu = BottomMenu { [weak self] in
        self?.isChatModeEnabled = false
        self?.aimybox?.startRecognition()
    } stopRecognition: { [weak self] in
        self?.aimybox?.standby()
    } applayText: { [weak self] query in
        self?.isChatModeEnabled = true
        self?.sendUserReplay(text: query)
    } textDidChange: { [weak self] in
        self?.scrollToBottomIfNeeded()
    } suggestionTapped: { [weak self] text in
        self?.sendUserReplay(text: text)
    }

    private
    lazy var bottomConstraint = bottomMenu.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

    override
    func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(bottomMenu)
        view.addSubview(loaderView)

        bottomConstraint.activate()
        bottomMenu.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        bottomMenu.rightAnchor.constraint(equalTo: view.rightAnchor).activate()

        tableView.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor).activate()
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).activate()
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).activate()
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).activate()
        tableView.translatesAutoresizingMaskIntoConstraints = false

        loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor).activate()
        loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor).activate()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    override
    func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showLoading()
    }

    override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        initializeAimybox()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc
    private
    func keyboardWillShow(notification: NSNotification) {
        guard
            let size = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            return
        }
        bottomConstraint.constant = -size.height + view.safeAreaInsets.bottom
        asyncAfter(delay: 0.26) {
            self.scrollToBottomIfNeeded()
        }
    }

    @objc
    private
    func keyboardWillHide() {
        bottomConstraint.constant = 0
    }

    private
    func scrollToBottomIfNeeded() {
        if !rows.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: rows.count - 1, section: 0), at: .bottom, animated: true)
        }
    }

    private
    func sendUserReplay(text: String) {
        aimybox?.sendRequest(query: text)
        rows.append(UserReply(text: text))
        scrollToBottomIfNeeded()
        bottomMenu.suggestions = []
    }

    private
    func startLoadDefaultCards() {
        aimybox?.sendRequest(query: "проверка карточек")
    }

    private
    func showLoading() {
        loaderView.startAnimating()
        tableView.isHidden = true
        bottomMenu.isHidden = true
    }

    private
    func hideLoading() {
        loaderView.stopAnimating()
        tableView.isHidden = false
        bottomMenu.isHidden = false
        aimybox?.standby()
    }

    private
    func initializeAimybox() {
        showLoading()
        // swiftlint:disable:next line_length
        let aiRoute = URL(static: "https://bot.jaicp.com/chatapi/webhook/zenbox/JdAFcjNb:13156b1d7f4adcc27196cb87e5a987362510f7d2")
        let folderID = "b1gvt2nubho67sa74uqh"
        let provider = IAMTokenGenerator(passport: "AgAAAAAjWu2CAATuwWlt16g0F0IYrunICaVEoUs")
        let synthesisConfig = YandexSynthesisConfig(voice: "kuznetsov_male", emotion: "good", speed: 1.0)

        guard
            let speechToText = YandexSpeechToText(tokenProvider: provider, folderID: folderID),
            let textToSpeech = YandexTextToSpeech(tokenProvider: provider, folderID: folderID, config: synthesisConfig)
        else {
            showError { [weak self] in
                self?.initializeAimybox()
            }
            return
        }

        AimyboxResponse.registerReplyType(of: CardReply.self, key: "card")
        AimyboxResponse.registerReplyType(of: ExchangeRateReply.self, key: "exchange_rate")
        AimyboxResponse.registerReplyType(of: StockMarketReply.self, key: "stock_market")
        AimyboxResponse.registerReplyType(of: WeatherReply.self, key: "weather")

        let dialogAPI = AimyboxDialogAPI(unitKey: aiUnitKey, route: aiRoute)
        let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)
        aimybox = AimyboxBuilder.aimybox(with: config)
        aimybox?.delegate = self

        startLoadDefaultCards()
    }

    private
    func showError(action: (() -> Void)? = nil) {

        let alert = UIAlertController(
            title: nil,
            message: errorDescription,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: errorButtonTitle, style: .default) { _ in
                asyncAfter(delay: 1) {
                    action?()
                }
            }
        )
        show(alert, sender: nil)
    }

    private
    func playSound(type: SoundType) {
        player = AVPlayer(url: type.url)
        player?.play()
    }

}

extension MainViewController: AimyboxDelegate {

    func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else {
                return
            }
            if newState == .listening {
                this.playSound(type: .in)
            } else if oldState == .listening {
                this.playSound(type: .out)
            }
            switch newState {
            case .listening:
                this.bottomMenu.query = "👂🏻"
                if this.isChatModeEnabled {
                    this.aimybox?.standby()
                }
            case .processing:
                this.bottomMenu.query = "🤔"
            case .speaking:
                this.bottomMenu.query = "💬"
            case .standby:
                this.bottomMenu.query = ""
            }
            self?.view.setNeedsLayout()
            asyncAfter(delay: 0.01, this.scrollToBottomIfNeeded)
        }
    }

    func dialogAPI(received response: Response) {
        let suggestions = response.replies.compactMap { ($0 as? ButtonsReply)?.buttons }.flatMap { $0 }
        let newRows = response.replies.filter { !($0 is ButtonsReply) }

        DispatchQueue.main.async { [weak self] in
            self?.rows.append(contentsOf: newRows)

            if self?.loaderView.isHidden == false {
                self?.hideLoading()
                return
            }

            self?.bottomMenu.suggestions = suggestions
            self?.scrollToBottomIfNeeded()
            if !response.question {
                self?.aimybox?.standby()
            }
        }
    }

    func dialogAPI(timeout request: Request) {
        DispatchQueue.main.async { self.showError() }
        resetBottomState()
    }

    func dialogAPI(client error: Error) {
        DispatchQueue.main.async {
            self.hideLoading()
            self.showError()
        }
        resetBottomState()
    }

    func dialogAPIProcessingCancellation() {
        resetBottomState()
    }

    func stt(_ stt: SpeechToText, recognitionPartial result: String) {
        guard !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.bottomMenu.query = result
            self?.view.setNeedsLayout()
            self?.scrollToBottomIfNeeded()
        }
    }

    func stt(_ stt: SpeechToText, recognitionFinal result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.rows.append(UserReply(text: result))
        }
    }

    func sttEmptyRecognitionResult(_ stt: SpeechToText) {
        resetBottomState()
    }

    func ttsDataReceived(_ tts: TextToSpeech) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechSequenceStarted sequence: [AimyboxSpeech]) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechStarted speech: AimyboxSpeech) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechEnded speech: AimyboxSpeech) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechSequenceCompleted sequence: [AimyboxSpeech]) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechSkipped speech: AimyboxSpeech) {
        debugPrint(#function)
    }

    func ttsSpeakersUnavailable(_ tts: TextToSpeech) {
        debugPrint(#function)
    }

    func tts(_ tts: TextToSpeech, speechSequenceCancelled sequence: [AimyboxSpeech]) {
        debugPrint(#function)
    }

    private
    func resetBottomState() {
        DispatchQueue.main.async { [weak self] in
            self?.bottomMenu.state = .default
        }
    }

}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch rows[indexPath.row] {
        case let cardReply as CardReply:
            return tableView.dequeueReusableCell(of: DefaultCell.self, indexPath: indexPath).with {
                $0.cardReply = cardReply
            }
        case let textReplay as TextReply:
            return tableView.dequeueReusableCell(of: DefaultCell.self, indexPath: indexPath).with {
                $0.textReplay = textReplay
            }
        case let imageReply as ImageReply:
            return tableView.dequeueReusableCell(of: DefaultCell.self, indexPath: indexPath).with {
                $0.imageReply = imageReply
            }
        case let userReplay as UserReply:
            return tableView.dequeueReusableCell(of: ChatCell.self, indexPath: indexPath).with {
                $0.userReplay = userReplay
            }
        case let weatherReply as WeatherReply:
            return tableView.dequeueReusableCell(of: WeatherCell.self, indexPath: indexPath).with {
                $0.weatherReply = weatherReply
            }
        case let exchangeRateReply as ExchangeRateReply:
            return tableView.dequeueReusableCell(of: ExchangeRateCell.self, indexPath: indexPath).with {
                $0.exchangeRateReply = exchangeRateReply
            }
        case let stockMarketReply as StockMarketReply:
            return tableView.dequeueReusableCell(of: StockMarketCell.self, indexPath: indexPath).with {
                $0.stockMarketReply = stockMarketReply
            }
        default:
            fatalError()
        }
    }

}

private
let aiUnitKey: String = {
    guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
        fatalError()
    }
    return uuid
}()

private
let errorButtonTitle = "Хорошо"

private
let errorDescription = """
    Голосовой ассистент временно недоступен. Проверьте соединение с интернетом и попробуйте ещё раз.
    """
