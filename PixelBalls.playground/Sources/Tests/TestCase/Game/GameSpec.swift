import XCTest

public class GameSpec: XCTestCase {

    var sut: Game!

    override public func tearDown() {
        super.tearDown()
        sut = nil
    }

    func testInitializeWithSize() {
        sut = Game(size: 8)

        XCTAssertTrue(sut.gameFieldViewModels.count == 64, "Uncorrect number of game field view models")
    }

    func testGameStartNumberOfBalls() {
        sut = Game(size: 8)

        sut.startGame()

        let numberOfSetedBalls = sut.gameFieldViewModels.filter { viewModel -> Bool in viewModel.ball != nil }
        XCTAssert(numberOfSetedBalls.count == 3, "Uncorrect number of balls")
    }

    func testGameStartNumberOfNextBalls() {
        sut = Game(size: 8)
        sut.startGame()

        let numberOfNextBalls = sut.nextBallViewModels.count
        XCTAssert(numberOfNextBalls == 3, "Uncorrect number of next balls")
    }

    func testIsOtherBallSelected() {
        sut = Game(size: 8)
        let selectedGameField = GameFieldViewModel()
        selectedGameField.isSelected = true
        let unselectedGameField = GameFieldViewModel()
        unselectedGameField.isSelected = false

        sut.gameFieldViewModels = [selectedGameField, unselectedGameField]

        XCTAssertFalse(sut.isOtherGameFieldSelected(except: selectedGameField), "Uncorrect isOtherGameFieldSelected status")
        XCTAssertTrue(sut.isOtherGameFieldSelected(except: unselectedGameField), "Uncorrect isOtherGameFieldSelected status")
    }

    func testSelectFieldUnselectField() {
        sut = Game(size: 8)
        let selectedGameField = GameFieldViewModel()
        selectedGameField.isSelected = true
        selectedGameField.ball = .red
        let unselectedGameField = GameFieldViewModel()
        unselectedGameField.isSelected = false
        unselectedGameField.ball = .blue

        sut.gameFieldViewModels = [selectedGameField, unselectedGameField]
        sut.selectField(selectedGameField)

        XCTAssert(selectedGameField.isSelected == false, "Uncorrect isSelected value")
        XCTAssert(unselectedGameField.isSelected == false, "Uncorrect isSelected value")
    }

    func testSelectFieldNotSelectField() {
        sut = Game(size: 8)
        let selectedGameField = GameFieldViewModel()
        selectedGameField.isSelected = true
        selectedGameField.ball = .red
        let unselectedGameField = GameFieldViewModel()
        unselectedGameField.isSelected = false
        unselectedGameField.ball = .blue

        sut.gameFieldViewModels = [selectedGameField, unselectedGameField]
        sut.selectField(unselectedGameField)

        XCTAssert(unselectedGameField.isSelected == false, "Uncorrect isSelected value")
        XCTAssert(selectedGameField.isSelected == true, "Uncorrect isSelected value")
    }

    func testIsNearBall() {
        sut = Game(size: 3)
        XCTAssertTrue(sut.isNearBall(rootIndex: 1, checkBallIndex: 0))
        XCTAssertTrue(sut.isNearBall(rootIndex: 0, checkBallIndex: 1))
        XCTAssertTrue(sut.isNearBall(rootIndex: 7, checkBallIndex: 6))
        XCTAssertTrue(sut.isNearBall(rootIndex: 6, checkBallIndex: 7))
        XCTAssertFalse(sut.isNearBall(rootIndex: 3, checkBallIndex: 2))
        XCTAssertFalse(sut.isNearBall(rootIndex: 2, checkBallIndex: 3))
        XCTAssertFalse(sut.isNearBall(rootIndex: 5, checkBallIndex: 6))
        XCTAssertFalse(sut.isNearBall(rootIndex: 6, checkBallIndex: 5))
        XCTAssertTrue(sut.isNearBall(rootIndex: 4, checkBallIndex: 1))
        XCTAssertTrue(sut.isNearBall(rootIndex: 1, checkBallIndex: 4))
        XCTAssertTrue(sut.isNearBall(rootIndex: 4, checkBallIndex: 5))
        XCTAssertTrue(sut.isNearBall(rootIndex: 5, checkBallIndex: 4))
        XCTAssertTrue(sut.isNearBall(rootIndex: 4, checkBallIndex: 7))
        XCTAssertTrue(sut.isNearBall(rootIndex: 7, checkBallIndex: 4))
        XCTAssertTrue(sut.isNearBall(rootIndex: 3, checkBallIndex: 4))
        XCTAssertTrue(sut.isNearBall(rootIndex: 4, checkBallIndex: 3))
        XCTAssertFalse(sut.isNearBall(rootIndex: 6, checkBallIndex: 5))
        XCTAssertFalse(sut.isNearBall(rootIndex: 5, checkBallIndex: 6))
        XCTAssertFalse(sut.isNearBall(rootIndex: 2, checkBallIndex: 3))
        XCTAssertFalse(sut.isNearBall(rootIndex: 3, checkBallIndex: 2))
        XCTAssertFalse(sut.isNearBall(rootIndex: -1, checkBallIndex: 9))
        XCTAssertFalse(sut.isNearBall(rootIndex: 8, checkBallIndex: 12))
    }

    func testareBallsThisSame() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[0].ball = .red
        sut.gameFieldViewModels[1].ball = .red
        sut.gameFieldViewModels[2].ball = .blue
        sut.gameFieldViewModels[3].ball = .blue

        XCTAssertTrue(sut.areBallsThisSame(rootIndex: 0, nextIndex: 1))
        XCTAssertTrue(sut.areBallsThisSame(rootIndex: 3, nextIndex: 2))
        XCTAssertFalse(sut.areBallsThisSame(rootIndex: 1, nextIndex: 2))
        XCTAssertFalse(sut.areBallsThisSame(rootIndex: 0, nextIndex: 3))
    }

    func testSelectedField() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[2].isSelected = true

        XCTAssert(sut.gameFieldViewModels[2] === sut.selectedField)
    }

    func testSelectedFieldIndex() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[3].isSelected = true

        XCTAssert(sut.selectedFieldIndex == 3, "Uncorrect selected index")
    }

    func testEmptyFields() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[2].ball = .red

        XCTAssert(sut.emptyFields?.count == 3, "Uncorrect number of empty fields")
        XCTAssertTrue(sut.gameFieldViewModels[0].isFieldEmpty, "Uncorrect isFieldEmpty value")
        XCTAssertTrue(sut.gameFieldViewModels[1].isFieldEmpty, "Uncorrect isFieldEmpty value")
        XCTAssertTrue(sut.gameFieldViewModels[3].isFieldEmpty, "Uncorrect isFieldEmpty value")
    }

    func testIndexOfGameField() {
        sut = Game(size: 2)

        XCTAssert(sut.indexOfGameField(sut.gameFieldViewModels[2]) == 2, "Uncorrect index")
    }

    func testIsOtherGameFieldSelectedCaseOne() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[0].isSelected = true
        sut.gameFieldViewModels[1].isSelected = true

        XCTAssertTrue(sut.isOtherGameFieldSelected(except: sut.gameFieldViewModels[0]), "Should return true")
    }

    func testIsOtherGameFieldSelectedCaseTwo() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[0].isSelected = true

        XCTAssertFalse(sut.isOtherGameFieldSelected(except: sut.gameFieldViewModels[0]), "Should return false")
    }

    func testSelectField() {
        sut = Game(size: 2)
        sut.gameFieldViewModels[1].ball = .red
        sut.selectField(sut.gameFieldViewModels[1])

        XCTAssertTrue(sut.gameFieldViewModels[1].isSelected, "Should be selected")

        sut.selectField(sut.gameFieldViewModels[1])

        XCTAssertFalse(sut.gameFieldViewModels[1].isSelected, "Should be unselected")
    }

}
