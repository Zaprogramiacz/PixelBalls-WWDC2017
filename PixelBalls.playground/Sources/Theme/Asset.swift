import Foundation

public enum Asset: String, Showable {
    case title

    public func stringValue() -> String {
        return self.rawValue
    }
}
