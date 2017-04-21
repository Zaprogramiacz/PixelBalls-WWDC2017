import XCTest

public class Int_RandomNumberSpec: XCTestCase {

    var number: Int!
    var isCorrect: Bool!

    override public func tearDown() {
        number = nil
        isCorrect = nil
    }

    func testRandomNumberFrom0To5() {
        number = Int.randomNumber(from: 0, to: 5)
        isCorrect = number >= 0 && number <= 5
        XCTAssertTrue(isCorrect, "Uncorrect number")
    }

    func testRandomNumberFrom1To2() {
        number = Int.randomNumber(from: 1, to: 2)
        isCorrect = number >= 1 && number <= 2
        XCTAssertTrue(isCorrect, "Uncorrect number")
    }

    func testRadnomNumberFrom0To0() {
        number = Int.randomNumber(from: 0, to: 0)
        isCorrect = number == 0
        XCTAssertTrue(isCorrect, "Uncorrect number")
    }

    func testRadnomNumberFrom3To3() {
        number = Int.randomNumber(from: 3, to: 3)
        isCorrect = number == 3
        XCTAssertTrue(isCorrect, "Uncorrect number")
    }

}
