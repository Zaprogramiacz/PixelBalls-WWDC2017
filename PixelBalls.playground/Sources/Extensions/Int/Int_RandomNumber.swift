import Foundation

extension Int {

    public static func randomNumber(from: Int, to: Int) -> Int {
        if from == to { return to }
        if from > to { fatalError("From value greather than to value") }
        return Int(arc4random()) % (from - to) + from
    }

}
