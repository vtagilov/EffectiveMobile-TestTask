import Speech
import AVFoundation

final class SpeechRecognitionService: NSObject, SFSpeechRecognizerDelegate {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    var onTextRecognized: ((String) -> Void)?
    var onError: ((Error?) -> Void)?
    
    override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    func startRecognition() {
        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            onError?(NSError(domain: "SpeechRecognitionService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Распознавание недоступно"]))
            return
        }
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            onError?(error)
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                self.onTextRecognized?(result.bestTranscription.formattedString)
            }
            if error != nil {
                self.stopRecognition()
                self.onError?(error)
            }
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            onError?(error)
        }
    }
    
    func stopRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask = nil
    }
}
