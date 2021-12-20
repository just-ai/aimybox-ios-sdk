import Foundation
import AVFoundation

final
class VAT {

    private
    let predictor: Predictor = {
        if
            let vadPath = Bundle.main.jitPath(named: "vad_mobile"),
            let featureExtractorPath = Bundle.main.jitPath(named: "feature_extractor_mobile"),
            let modelPath = Bundle.main.jitPath(named: "model_mobile"),
            let module = Predictor(vadPath: vadPath, featureExtractorPath: featureExtractorPath, modelPath: modelPath)
        {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()

    private
    let audioEngine: AVAudioEngine

    private
    let inputNode: AVAudioInputNode

    private
    let inputFormat: AVAudioFormat

    private
    let converter: AVAudioConverter

    private
    let keyPhraseHandler: (() -> Void)

    private
    let streamBuffer = StreamBuffer()

    private
    var isTtriggeredOnce = false

    private
    var triggeredProba: Float = 0

    private
    var chunks: [Float] = []

    init(keyPhraseHandler: @escaping (() -> Void)) {
        self.audioEngine = AVAudioEngine()
        self.inputNode = audioEngine.inputNode
        self.inputFormat = inputNode.inputFormat(forBus: 0)
        self.converter = AVAudioConverter(from: inputFormat, to: Constants.modelInputFormat)!
        self.keyPhraseHandler = keyPhraseHandler
    }

    func requestRecordPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            debugPrint("requestRecordPermission \(granted)")
         }
    }

    func start() {
        guard !audioEngine.isRunning else {
            return
        }

        inputNode.installTap(onBus: 0, bufferSize: 2048, format: inputFormat) { [weak self] buffer, time in
            let data = buffer.data(using: self?.converter)
            self?.chunks.append(contentsOf: data)

            while (self?.chunks.count ?? 0) > Constants.chunkLength {
                let chunk = self?.chunks.prefix(Constants.chunkLength) ?? []
                self?.chunks.removeFirst(Constants.chunkLength)
                self?.processStream(currentChunk: Array(chunk))
            }
        }
        try? audioEngine.start()
    }

    func stop() {
        audioEngine.stop()
        inputNode.removeTap(onBus: 0)
    }

    private
    func processStream(currentChunk: [Float]) {
        var chunk = currentChunk
        var speechProbability: Double = 0
        chunk.withUnsafeMutableBytes { vadPointer in
            speechProbability = predictor.recognizeVAD(
                vadPointer.baseAddress!,
                bufLength: Int32(Constants.chunkLength)
            )?.doubleValue ?? 0
        }

        if speechProbability > Constants.vadThreshold || isTtriggeredOnce == true {
            streamBuffer.add(chunks: currentChunk)
            isTtriggeredOnce = true
        } else {
            streamBuffer.add(chunks: currentChunk)
            streamBuffer.clear()
        }

        if streamBuffer.isFilled {
            var keywordProbability: Double = 0
            var audioDataToPredict = streamBuffer.chunks

            audioDataToPredict.withUnsafeMutableBytes { fePointer in
                keywordProbability = predictor.recognizeKeyPhrase(
                    fePointer.baseAddress!,
                    bufLength: Int32(VAT.Constants.minPredictionSamples)
                )?.doubleValue ?? 0
            }

            if keywordProbability > Constants.clfThreshold && !isTtriggeredOnce {
                isTtriggeredOnce = true
            } else if keywordProbability > Constants.clfPostThreshold {
                isTtriggeredOnce = false
                streamBuffer.clear(all: true)
                DispatchQueue.main.async {
                    self.keyPhraseHandler()
                }
            } else {
                isTtriggeredOnce = false
            }
        }
    }

}

private
extension AVAudioPCMBuffer {

    func data(using converter: AVAudioConverter?) -> [Float] {
        let capacity = AVAudioFrameCount(VAT.Constants.modelInputFormat.sampleRate) * frameLength / AVAudioFrameCount(format.sampleRate)
        guard
            let converter = converter,
            let modelBuffer = AVAudioPCMBuffer(pcmFormat: VAT.Constants.modelInputFormat, frameCapacity: capacity)
        else {
            return []
        }

        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            outStatus.pointee = .haveData
            return self
        }

        var error: NSError? = nil
        let status = converter.convert(to: modelBuffer, error: &error, withInputFrom: inputBlock)
        assert(status != .error)
        assert(error == nil, error!.localizedDescription)

        let pointer = UnsafeBufferPointer(start: modelBuffer.floatChannelData![0], count:Int(modelBuffer.frameLength))
        return Array(pointer)
    }

}

private
extension VAT {

    struct Constants {

        static var vadThreshold = 0.25

        static var chunkLength = 4_000

        static var minPredictionSamples = 32_000

        static var paddingPredictionSamples = 2_000

        static var clfThreshold = 0.66

        static var clfPostThreshold = 0.4

        static var modelInputFormat: AVAudioFormat = {
            guard let format = AVAudioFormat.init(
                commonFormat: .pcmFormatFloat32,
                sampleRate: 16_000,
                channels: 1,
                interleaved: false
            ) else {
                fatalError()
            }
            return format
        }()

        private
        init() {}
    }

    final class StreamBuffer {

        private(set)
        var chunks: [Float] = []

        var isFilled: Bool {
            chunks.count >= VAT.Constants.minPredictionSamples
        }

        func add(chunks newChunks: [Float]) {
            chunks.append(contentsOf: newChunks)
            if isFilled {
                chunks.removeFirst(chunks.count - VAT.Constants.minPredictionSamples)
            }
        }

        func clear(all: Bool = false) {
            if all {
                chunks.removeAll()
            } else if chunks.count > VAT.Constants.paddingPredictionSamples {
                chunks.removeFirst(chunks.count - VAT.Constants.paddingPredictionSamples)
            }
        }

    }

}

private
extension Bundle {

    func jitPath(named name: String) -> String? {
        self.path(forResource: name, ofType: "jit")
    }

}
