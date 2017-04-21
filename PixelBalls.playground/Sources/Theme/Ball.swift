import Foundation

public enum Ball: String, Showable {
    case black
    case blue
    case green
    case orange
    case pink
    case purple
    case red
    case turquoise
    case yellow

    static let allBalls = [black, blue, green, orange, pink, purple, red, turquoise, yellow]
    static let gameBalls = [blue, green, red, yellow, orange]

    public func stringValue() -> String {
        return self.rawValue
    }
}

public protocol Showable {
    func stringValue() -> String
}
