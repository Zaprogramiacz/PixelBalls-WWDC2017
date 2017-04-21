import Foundation

final class Game {

    typealias DidUpdateScoreClosure = (_ score: Int) -> ()
    var didUpdateScoreClosure: DidUpdateScoreClosure?

    typealias GameOverClosure = (_ score: Int) -> ()
    var gameOverClosure: GameOverClosure?

    var gameFieldViewModels: [GameFieldViewModel] = []
    var nextBallViewModels: [BallDisplayViewModel] = []

    var score = 0 {
        didSet {
            didUpdateScoreClosure?(score)
        }
    }

    init(size: Int) {
        self.size = size
        createGameFieldViewModels(size: size)
        createNextBallViewModels()
    }

    func startGame() {
        addStartingBalls()
        drawNextBalls()
    }

    // MARK: -

    private func createGameFieldViewModels(size: Int) {
        for _ in 1...(size*size) {
            let viewModel = GameFieldViewModel()
            viewModel.gameFieldDidSelectedClosure = { [weak self] viewModel in
                self?.makeMove(viewModel)
            }
            gameFieldViewModels.append(viewModel)
        }
    }

    private func createNextBallViewModels() {
        for _ in 1...3 {
            nextBallViewModels.append(BallDisplayViewModel())
        }
    }

    private func makeMove(_ viewModel: GameFieldViewModel) {
        viewModel === selectedField || selectedField == nil ? selectField(viewModel) : moveBall(viewModel)
    }

    func selectField(_ viewModel: GameFieldViewModel) {
        if viewModel.isFieldEmpty == false && isOtherGameFieldSelected(except: viewModel) == false {
            viewModel.isSelected = !viewModel.isSelected
        }
    }

    func moveBall(_ viewModel: GameFieldViewModel) {
        guard let selectedIndex = selectedFieldIndex,
            let targetIndex = indexOfGameField(viewModel) else { return }
        checkPath(startIndex: selectedIndex, endIndex: targetIndex)
        if !viewModel.fieldWasChecked {
            viewModel.cannotMoveThereClosure?()
            playCannotMoveSound()
        } else if viewModel.isFieldEmpty && viewModel !== selectedField {
            viewModel.ball = selectedField?.ball
            selectedField?.ball = nil
            updateScore(viewModel)
            addNextBallsToGameField()
            resetCheckedFieldsStatus()
            checkAvailableFields()
            playSound()
        }
    }

    private func addStartingBalls() {
        var addedBalls = 0
        while addedBalls < 3 {
            let viewModel = randomViewModel
            if viewModel.isFieldEmpty == false { continue }
            viewModel.ball = randomBall
            addedBalls += 1
        }
    }

    private func addNextBallsToGameField() {
        nextBallViewModels.forEach { viewModel in
            guard let emptyField = randomEmptyField else { return }
            emptyField.ball = viewModel.ball
            updateScore(emptyField)
        }
        drawNextBalls()
    }

    private func updateScore(_ viewModel: GameFieldViewModel) {
        var checkedGameFields: [GameFieldViewModel] = [viewModel]
        let vertical = checkGameFields(rootGameField: viewModel, nextBall: size)
        let horizontal = checkGameFields(rootGameField: viewModel, nextBall: 1)
        let firstDiagonal = checkGameFields(rootGameField: viewModel, nextBall: size + 1)
        let secondDiagonal = checkGameFields(rootGameField: viewModel, nextBall: size - 1)
        if vertical.count >= 4 { checkedGameFields.append(contentsOf: vertical) }
        if horizontal.count >= 4 { checkedGameFields.append(contentsOf: horizontal) }
        if firstDiagonal.count >= 4 { checkedGameFields.append(contentsOf: firstDiagonal) }
        if secondDiagonal.count >= 4 { checkedGameFields.append(contentsOf: secondDiagonal) }
        addScore(checkedGameFields)
    }

    func checkGameFields(rootGameField: GameFieldViewModel, nextBall: Int) -> [GameFieldViewModel] {
        var checkedGameFields: [GameFieldViewModel] = []
        guard let indexOfRoot = indexOfGameField(rootGameField) else { return [] }
        var previousIndex = indexOfRoot
        var nextIndex = indexOfRoot
        while isNearBall(rootIndex: previousIndex, checkBallIndex: previousIndex-nextBall) &&
            areBallsThisSame(rootIndex: indexOfRoot, nextIndex: previousIndex-nextBall) {
            checkedGameFields.append(gameFieldViewModels[previousIndex-nextBall])
            previousIndex -= nextBall
        }
        while isNearBall(rootIndex: nextIndex, checkBallIndex: nextIndex+nextBall) &&
            areBallsThisSame(rootIndex: indexOfRoot, nextIndex: nextIndex+nextBall) {
            checkedGameFields.append(gameFieldViewModels[nextIndex+nextBall])
            nextIndex += nextBall
        }
        return checkedGameFields
    }

    func areBallsThisSame(rootIndex: Int, nextIndex: Int) -> Bool {
        guard rootIndex >= 0, nextIndex >= 0 else { return false }
        guard rootIndex < size*size, nextIndex < size*size else { return false }
        let rootViewModel = gameFieldViewModels[rootIndex]
        let nextViewModel = gameFieldViewModels[nextIndex]
        guard let rootViewModelBall = rootViewModel.ball, let nextViewModelBall = nextViewModel.ball else { return false }
        return rootViewModelBall == nextViewModelBall
    }

    func isNearBall(rootIndex: Int, checkBallIndex: Int) -> Bool{
        guard checkBallIndex >= 0, rootIndex >= 0 else { return false }
        guard checkBallIndex < size*size, rootIndex < size*size else { return false }
        if rootIndex % size == 0 && checkBallIndex == rootIndex - 1 { return false }
        if rootIndex % size == size - 1 && checkBallIndex == rootIndex + 1 { return false }
        return true
    }

    private func addScore(_ viewModels: [GameFieldViewModel]) {
        let numberOfPoionts = viewModels.count
        if numberOfPoionts >= 5 {
            score += numberOfPoionts
            playPointsSound()
            viewModels.forEach { $0.ball = nil }
        }
    }

    private func drawNextBalls() {
        nextBallViewModels.forEach { viewModel in viewModel.ball = randomBall }
    }

    private func checkPath(startIndex: Int, endIndex: Int) {
        guard startIndex >= 0, endIndex >= 0 else { return }
        guard startIndex < size*size, endIndex < size*size else { return }
        guard let selectedField = selectedField else { return }
        let startGameField = gameFieldViewModels[startIndex]
        if (startGameField.fieldWasChecked == false && startGameField.isFieldEmpty) || startGameField === selectedField {
            startGameField.fieldWasChecked = true
            if isNearBall(rootIndex: startIndex, checkBallIndex: startIndex + 1) {
                checkPath(startIndex: startIndex + 1, endIndex: endIndex)
            }
            if isNearBall(rootIndex: startIndex, checkBallIndex: startIndex - 1) {
                checkPath(startIndex: startIndex - 1, endIndex: endIndex)
            }
            if isNearBall(rootIndex: startIndex, checkBallIndex: startIndex + size) {
                checkPath(startIndex: startIndex + size, endIndex: endIndex)
            }
            if isNearBall(rootIndex: startIndex, checkBallIndex: startIndex - size) {
                checkPath(startIndex: startIndex - size, endIndex: endIndex)
            }
        }
    }

    private func resetCheckedFieldsStatus() {
        gameFieldViewModels.forEach { viewModel in viewModel.fieldWasChecked = false }
    }

    private func checkAvailableFields() {
        if emptyFields == nil { gameOverClosure?(score) }
    }

    // MARK: Helpers

    var selectedField: GameFieldViewModel? {
        return gameFieldViewModels.first(where: { viewModel -> Bool in viewModel.isSelected == true })
    }

    var selectedFieldIndex: Int? {
        guard let selectedField = selectedField else { return nil }
        return indexOfGameField(selectedField)
    }

    var emptyFields: [GameFieldViewModel]? {
        let emptyFields = gameFieldViewModels.filter({ viewModel -> Bool in viewModel.isFieldEmpty })
        return emptyFields.count == 0 ? nil : emptyFields
    }

    private let size: Int

    private var randomFieldNumber: Int {
        return Int.randomNumber(from: 0, to: gameFieldViewModels.count - 1)
    }

    private var randomBallNumber: Int {
        return Int.randomNumber(from: 0, to: Ball.gameBalls.count - 1)
    }

    private var randomViewModel: GameFieldViewModel {
        return gameFieldViewModels[randomFieldNumber]
    }

    private var randomBall: Ball {
        return Ball.gameBalls[randomBallNumber]
    }

    private var randomEmptyField: GameFieldViewModel? {
        guard let emptyFields = self.emptyFields else { return nil }
        return emptyFields[Int.randomNumber(from: 0, to: emptyFields.count - 1)]
    }

    func indexOfGameField(_ viewModel: GameFieldViewModel) -> Int? {
        var gameFieldIndex: Int?
        gameFieldViewModels.enumerated().forEach { index, gameFieldViewModel in
            if viewModel === gameFieldViewModel { gameFieldIndex = index }
        }
        return gameFieldIndex
    }

    func isOtherGameFieldSelected(except viewModel: GameFieldViewModel) -> Bool {
        return gameFieldViewModels
            .filter { gameFieldViewModel -> Bool in gameFieldViewModel !== viewModel }
            .filter { viewModel -> Bool in viewModel.isSelected == true }
            .count != 0
    }

}
