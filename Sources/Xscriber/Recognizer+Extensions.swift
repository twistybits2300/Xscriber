import Foundation
import Speech

@available(macOS 10.15, *)
extension Recognizer {
    public typealias Status = SFSpeechRecognizerAuthorizationStatus
}

@available(macOS 10.15, *)
extension Recognizer.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notDetermined:
            return "not determined"
        case .denied:
            return "denied"
        case .restricted:
            return "restricted"
        case .authorized:
            return "authorized"
        @unknown default:
            return "unknown default"
        }
    }
}
