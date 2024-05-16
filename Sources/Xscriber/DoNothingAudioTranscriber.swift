import Foundation

/// A non-functioning `AudioTranscriber` that serves as a backup
/// in case the initialization of `AudioFileTranscriber` fails.
@available(macOS 10.15, *)
public struct DoNothingAudioTranscriber: AudioTranscriber {
    public var isSpeechAvailable: Bool { false }
    public var hasPermission: Bool { false }
    public var recognizerStatus: Recognizer.Status { .notDetermined }
    public var isTranscribing: Bool { false }
    public var error: TranscriberError? { nil }
    public var transcriptionText: String? { nil }
    
    public init() throws { }
    public func requestPermission() { }
    public func transcribe(fileURL: URL) throws { }
    public func reset() { }
}
