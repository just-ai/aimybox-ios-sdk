import Aimybox
import AVFoundation

public
class AimyvoiceTextToSpeech: AimyboxComponent, TextToSpeech {
    /**
    Used to notify *Aimybox* state machine about events.
    */
    public
    var notify: (TextToSpeechCallback)?
    /** Aimyvoice Cloud Synthesis
    */
    private
    lazy var synthesisAPI = AimyvoiceSynthesisAPI(
        apiKey: apiKey,
        api: address,
        operation: operationQueue
    )
    /**
    */
    var player: AVPlayer?
    /**
    */
    var notificationQueue: OperationQueue
    /**
    */
    var isCancelled = false

    private
    let apiKey: String

    private
    let address: URL

    public
    init?(
        apiKey: String,
        api address: URL = URL(static: "https://aimyvoice.com/api/v1/synthesize")
    ) {
        self.notificationQueue = OperationQueue()
        self.apiKey = apiKey
        self.address = address
        super.init()
    }

    public
    func synthesize(contentsOf speeches: [AimyboxSpeech]) {
        isCancelled = false
        operationQueue.addOperation { [weak self] in
            self?.prepareAudioEngineForMultiRoute { engineIsReady in
                if engineIsReady {
                    self?.synthesize(speeches)
                } else {
                    self?.notify?(.failure(.speakersUnavailable))
                }
            }
        }
        operationQueue.waitUntilAllOperationsAreFinished()
    }

    public
    func stop() {
        isCancelled = true
        player?.pause()
    }

    public
    func cancelSynthesis() {
        operationQueue.addOperation { [weak self] in
            self?.isCancelled = true
        }
    }
    // MARK: - Internals

    private
    func synthesize(_ speeches: [AimyboxSpeech]) {
        guard let notify = notify else {
            return
        }

        notify(.success(.speechSequenceStarted(speeches)))

        speeches.unwrapSSML.forEach { speech in

            guard speech.isValid() && !isCancelled else {
                return notify(.failure(.emptySpeech(speech)))
            }

            synthesize(speech)
        }

        notify(
            isCancelled
                ? .failure(.speechSequenceCancelled(speeches))
                : .success(.speechSequenceCompleted(speeches))
        )
    }

    private
    func synthesize(_ speech: AimyboxSpeech) {
        if let textSpeech = speech as? TextSpeech {
            synthesize(textSpeech)
        } else if let audioSpeech = speech as? AudioSpeech {
            synthesize(audioSpeech)
        }
    }

    private
    func synthesize(_ textSpeech: TextSpeech) {
        let synthesisGroup = DispatchGroup()

        synthesisGroup.enter()
        synthesisAPI.request(text: textSpeech.text) { [weak self] in
            if let url = $0, self?.isCancelled == false {
                self?.notify?(.success(.speechDataReceived(textSpeech)))
                self?.synthesize(textSpeech, using: url)
            }
            synthesisGroup.leave()
        }
        synthesisGroup.wait()
    }

    private
    func synthesize(_ audioSpeech: AudioSpeech) {
        synthesize(audioSpeech, using: audioSpeech.audioURL)
    }

    private
    func synthesize(_ speech: AimyboxSpeech, using url: URL) {
        guard let notify = notify else {
            return
        }

        let synthesisGroup = DispatchGroup()

        let player = AVPlayer(url: url)

        let statusObservation = player.currentItem?.observe(\.status) { item, _ in
            switch item.status {
            case .failed:
                notify(.failure(.emptySpeech(speech)))
                synthesisGroup.leave()
            default:
                break
            }
        }

        let stopObservation = player.observe(\.rate) { _, _ in
            guard player.rate == 0 else {
                return
            }
            notify(.success(.speechEnded(speech)))
            synthesisGroup.leave()
        }
        let failedToPlayToEndObservation = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemFailedToPlayToEndTime,
            object: player.currentItem,
            queue: notificationQueue
        ) { _ in
            notify(.failure(.emptySpeech(speech)))
            synthesisGroup.leave()
        }

        synthesisGroup.enter()
        self.player = player
        if isCancelled {
            synthesisGroup.leave()
        } else {
            player.play()
            notify(.success(.speechStarted(speech)))
        }
        synthesisGroup.wait()

        self.player = nil
        stopObservation.invalidate()
        statusObservation?.invalidate()
        NotificationCenter.default.removeObserver(failedToPlayToEndObservation)
    }

    private
    func prepareAudioEngineForMultiRoute(_ completion: (Bool) -> Void) {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setMode(.default)

            try audioSession.setCategory(
                .playAndRecord,
                options: [.allowBluetoothA2DP, .defaultToSpeaker]
            )

            if audioSession.isOtherAudioPlaying {
                try audioSession.setActive(true, options: [.notifyOthersOnDeactivation])
            }

            completion(true)
        } catch {
            completion(false)
        }
    }

}
