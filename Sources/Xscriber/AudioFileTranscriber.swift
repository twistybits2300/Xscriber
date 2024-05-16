import Foundation
import Speech

@available(macOS 14.0, iOS 17.0, *)
@Observable
/// Handles the duties of transcribing audio from a 
/// file using the `macOS` speech recognition system.
public final class AudioFileTranscriber: AudioTranscriber {
    private let recognizer: SFSpeechRecognizer
    
    /// Indicates permission status for being able to recognize speech.
    public var recognizerStatus = Recognizer.Status.notDetermined
    
    /// Returns `true` when a transcription is in progress, `false` otherwise.
    public var isTranscribing: Bool = false

    /// This will be non-`nil` upon any errors encountered.
    public var error: TranscriberError? = nil
    
    /// This will be non-`nil` when transcription text has been returned
    /// after making a transcription request.
    public var transcriptionText: String? = nil
    
    // MARK: - Initialization
    /// Default initializer.
    /// - Throws: `TranscriberError.speechRecognizerInitFailure` if
    /// the `recognizer` can't be initialized (i.e. `SFSpeechRecognizer`
    /// `.init()?` returns `nil`).
    public init() throws {
        guard let speechRecognizer = SFSpeechRecognizer() else {
            throw TranscriberError.speechRecognizerInitFailure
        }
        
        self.recognizer = speechRecognizer
        self.recognizerStatus = recognizerStatus
    }
    
    // MARK: - AudioTranscriber
    /// Returns `true` if speech recognition is available on this
    /// device, `false` otherwise.
    public var isSpeechAvailable: Bool {
        recognizer.isAvailable
    }
    
    /// Returns `true` if the user has granted permission to use
    /// speech recognition, `false` otherwise.
    public var hasPermission: Bool {
        recognizerStatus == .authorized
    }
    
    /// Triggers a check of the speech recognition permission status.
    public func requestPermission() {
        Recognizer.requestAuthorization { [weak self] status in
            self?.recognizerStatus = status
        }
    }
    
    /// Performs a transcription of the audio file indicated by the 
    /// given `fileURL`.
    /// - Parameter fileURL: The URL of the file to be transcribed.
    /// - Throws: `TranscriberError.transcriptionError(URL, Error)` 
    /// if the transcription fails.
    public func transcribe(fileURL: URL) throws {
        let request = SFSpeechURLRecognitionRequest(url: fileURL)
        recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let error = error {
                self?.error = TranscriberError.transcriptionError(fileURL, error)
                self?.isTranscribing = false
            } else if let result = result {
                if result.isFinal {
                    self?.transcriptionText = result.bestTranscription.formattedString
                    self?.isTranscribing = false
                }
            }
        }
        self.isTranscribing = true
    }
    
    /// Resets to the default state.
    public func reset() {
        isTranscribing = false
        error = nil
        transcriptionText = nil
    }
}
