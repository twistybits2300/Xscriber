import Foundation
import Speech

@available(macOS 10.15, *)
public typealias Recognizer = SFSpeechRecognizer

/// Defines the responsibilities that a transcriber of audio must fulfill.
@available(macOS 10.15, *)
public protocol AudioTranscriber {
    /// Returns `true` if speech recognition is available on this device, `false` otherwise.
    var isSpeechAvailable: Bool { get }
    
    /// Returns `true` if the user has granted permission for speech recognition, `false` otherwise.
    var hasPermission: Bool { get }
    
    /// The current speech recognition permission status.
    var recognizerStatus: Recognizer.Status { get }
    
    /// Returns `true` when a transcription is in progress, `false` otherwise.
    var isTranscribing: Bool { get }
    
    /// This will be non-`nil` upon any errors encountered.
    var error: TranscriberError? { get }

    /// This will be non-`nil` when transcription text has been returned
    /// after making a transcription request.
    var transcriptionText: String? { get }

    /// Default initializer.
    /// - Throws on errors encountered while initializing.
    init() throws
    
    /// Triggers a check of the speech recognition permission status.
    func requestPermission()
    
    /// Performs a transcription of the audio file indicated by the given `fileURL`.
    /// - Parameter fileURL: The URL of the file to be transcribed.
    /// - Throws: `TranscriberError`
    func transcribe(fileURL: URL) throws
}

