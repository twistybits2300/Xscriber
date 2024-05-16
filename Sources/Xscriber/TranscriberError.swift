import Foundation

/// Indicates errors encountered during speech recognition.
///
/// - `speechRecognizerInitFailure`: Unable to initialize an `SFSpeechRecognizer`.
/// - `transcriptionError(URL, Error)`: Transcription of an audio file failed.
public enum TranscriberError: Error {
    case speechRecognizerInitFailure
    case transcriptionError(URL, Error)
}

// MARK: - LocalizedError
@available(macOS 13.0, iOS 16.0, *)
extension TranscriberError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .speechRecognizerInitFailure:
            return "speech recognizer init failure"
        case let .transcriptionError(fileURL, error):
            return "transcription of \(fileURL.path()) failed: \(error.localizedDescription)"
        }
    }
}
