import UIKit

final class NewGameView: UIView {

    private weak var delegate: NewGameViewDelegate?

    var score = 0 {
        didSet {
            scoreView.textLabel.text = "Score: \(score)"
        }
    }

    var gameFieldViewModels: [GameFieldViewModel] = [] {
        didSet {
            gameFields.forEach { $0.removeFromSuperview() }
            createGameField()
            setupGameFieldLayout()
        }
    }

    var nextBallViewModels: [BallDisplayViewModel] = [] {
        didSet {
            nextBallFields.forEach { $0.removeFromSuperview() }
            createNextBallFields()
            setupNextBallFieldsLayout()
        }
    }

    init(delegate: NewGameViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor.darkGray
        addSubviews()
        setupLayout()
        setupButtonActions()
        hideElements()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Button actions

    private func setupButtonActions() {
        backButton.buttonActionClosure = { [weak self] in
            self?.delegate?.didTapBackButton()
        }
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(playgroundContainer)
        addSubview(nextBallsContainer)
        addSubview(backButton)
        addSubview(scoreViewContainer)
        scoreViewContainer.addSubview(scoreView)
        addSubview(gameOverView)
    }

    private func createNextBallFields() {
        nextBallViewModels.forEach { viewModel in
            let gameField = GameField()
            viewModel.ballChangedClosure = { [weak gameField] image in
                guard let gameField = gameField else { return }
                gameField.ballImageView.image = image
            }
            nextBallsContainer.addSubview(gameField)
            nextBallFields.append(gameField)
        }
    }

    private func createGameField() {
        gameFieldViewModels.enumerated().forEach { _, viewModel in
            let gameField = GameField()
            viewModel.ballChangedClosure = { [weak gameField] image in
                guard let gameField = gameField else { return }
                gameField.ballImage = image
            }
            gameField.buttonActionClosure = { [weak viewModel] in
                guard let viewModel = viewModel else { return }
                viewModel.gameFieldDidSelectedClosure?(viewModel)
            }
            viewModel.selectFieldClosure = { [weak gameField] isSelected in
                gameField?.isSelected = isSelected
            }
            viewModel.cannotMoveThereClosure = { [weak gameField] in
                gameField?.showRedBackground()
            }
            playgroundContainer.addSubview(gameField)
            gameFields.append(gameField)
        }
    }

    let gameOverView = SubviewsFactory.gameOverView()
    private var gameFields: [GameField] = []
    private var nextBallFields: [GameField] = []
    private let backgroundView = BackgroundView(numberOfBalls: 35)
    private let playgroundContainer = SubviewsFactory.createPlaygroundContainer()
    private let nextBallsContainer = SubviewsFactory.createPlaygroundContainer()
    private let scoreViewContainer = UIView(frame: .zero)
    private let scoreView = PixelTextView(text: "Score: 0")
    private let backButton = PixelButton(title: "Back")

    func showGameOverView(_ score: Int) {
        gameOverView.updateScoreLabel(score: score)
        gameOverView.layer.add(AnimationsFactory.showGameOverAnimation(), forKey: nil)
        gameOverView.isHidden = false
    }

    // MARK: Layout

    private func setupLayout() {
        setupBackgroundViewLayout()
        setupPlaygroundContainerLayout()
        setupNextBallsContainerLayout()
        setupScoreViewContainerLayout()
        setupScoreViewLayout()
        setupBackButtonLayout()
        setupGameOverViewLayout()
    }

    private func setupNextBallFieldsLayout() {
        let numberOfFields = 3
        let fieldsSpacing: CGFloat = 1
        let containerSpacing: CGFloat = 7
        nextBallFields.enumerated().forEach { index, nextBallGameField in
            nextBallGameField.translatesAutoresizingMaskIntoConstraints = false
            let isFirstInLine = index % numberOfFields == 0
            let isLastInLine = index % numberOfFields == numberOfFields - 1
            if isFirstInLine {
                nextBallGameField.leadingAnchor.constraint(equalTo: nextBallsContainer.leadingAnchor, constant: containerSpacing).isActive = true
            } else {
                let previous = nextBallFields[nextBallFields.index(before: index)]
                nextBallGameField.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: fieldsSpacing).isActive = true
            }
            if isLastInLine {
                nextBallGameField.trailingAnchor.constraint(equalTo: nextBallsContainer.trailingAnchor, constant: -containerSpacing).isActive = true
            }
            nextBallGameField.topAnchor.constraint(equalTo: nextBallsContainer.topAnchor, constant: containerSpacing).isActive = true
            nextBallGameField.bottomAnchor.constraint(equalTo: nextBallsContainer.bottomAnchor, constant: -containerSpacing).isActive = true
        }
    }

    private func setupGameFieldLayout() {
        let size = Int(sqrt(Double(gameFieldViewModels.count)))
        let fieldsSpacing: CGFloat = 1
        let playgroundSpacing: CGFloat = 7
        gameFields.enumerated().forEach { index, gameField in
            gameField.translatesAutoresizingMaskIntoConstraints = false
            let isFirstInLine = index % size == 0
            let isLastInLine = index % size == size - 1
            let isFirstLine = (index / size) == 0
            let isLastLine = (index / size) == (size-1)
            if isFirstInLine {
                gameField.leadingAnchor.constraint(equalTo: playgroundContainer.leadingAnchor, constant: playgroundSpacing).isActive = true
            } else {
                let previous = gameFields[gameFields.index(before: index)]
                gameField.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: fieldsSpacing).isActive = true
                gameField.widthAnchor.constraint(equalTo: previous.widthAnchor).isActive = true
            }
            if isLastInLine {
                gameField.trailingAnchor.constraint(equalTo: playgroundContainer.trailingAnchor, constant: -playgroundSpacing).isActive = true
            }
            if isFirstLine {
                gameField.topAnchor.constraint(equalTo: playgroundContainer.topAnchor, constant: playgroundSpacing).isActive = true
            } else {
                let topGameField = gameFields[index - size]
                gameField.topAnchor.constraint(equalTo: topGameField.bottomAnchor, constant: fieldsSpacing).isActive = true
            }
            if isLastLine {
                gameField.bottomAnchor.constraint(equalTo: playgroundContainer.bottomAnchor, constant: -playgroundSpacing).isActive = true
            }
            gameField.heightAnchor.constraint(equalTo: gameField.widthAnchor).isActive = true
        }
    }

    private func setupBackgroundViewLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func setupPlaygroundContainerLayout() {
        playgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        playgroundContainer.heightAnchor.constraint(equalTo: playgroundContainer.widthAnchor).isActive = true
        playgroundContainer.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor, constant: 20).isActive = true
        playgroundContainer.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor, constant: -20).isActive = true
        playgroundContainer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        playgroundContainer.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
    }

    private func setupNextBallsContainerLayout() {
        nextBallsContainer.translatesAutoresizingMaskIntoConstraints = false
        nextBallsContainer.leadingAnchor.constraint(equalTo: playgroundContainer.leadingAnchor).isActive = true
        nextBallsContainer.topAnchor.constraint(equalTo: playgroundContainer.bottomAnchor, constant: 10).isActive = true
    }

    private func setupScoreViewContainerLayout() {
        scoreViewContainer.translatesAutoresizingMaskIntoConstraints = false
        scoreViewContainer.leadingAnchor.constraint(equalTo: nextBallsContainer.trailingAnchor).isActive = true
        scoreViewContainer.trailingAnchor.constraint(equalTo: playgroundContainer.trailingAnchor).isActive = true
        scoreViewContainer.centerYAnchor.constraint(equalTo: nextBallsContainer.centerYAnchor).isActive = true
    }

    private func setupScoreViewLayout() {
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        scoreView.centerXAnchor.constraint(equalTo: scoreViewContainer.centerXAnchor).isActive = true
        scoreView.centerYAnchor.constraint(equalTo: scoreViewContainer.centerYAnchor).isActive = true
        scoreView.leadingAnchor.constraint(equalTo: scoreViewContainer.leadingAnchor, constant: 10).isActive = true
        scoreView.trailingAnchor.constraint(equalTo: scoreViewContainer.trailingAnchor, constant: -10).isActive = true
    }

    private func setupBackButtonLayout() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
    }

    private func setupGameOverViewLayout() {
        gameOverView.translatesAutoresizingMaskIntoConstraints = false
        gameOverView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        gameOverView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
    }

    // MARK: Animation

    func startAnimation() {
        showElements()
        backgroundView.startAnimation()
        backButton.layer.add(AnimationsFactory.positionYButtonAnimation(frame: frame), forKey: nil)
    }

    private func showElements() {
        backButton.isHidden = false
    }

    private func hideElements() {
        backButton.isHidden = true
    }

}

private extension NewGameView {

    struct SubviewsFactory {
        static func createPlaygroundContainer() -> UIView {
            let view = UIView(frame: .zero)
            view.backgroundColor = .gray
            view.layer.borderColor = UIColor.black.cgColor
            view.layer.borderWidth = 2
            view.layer.cornerRadius = 4
            return view
        }

        static func gameOverView() -> GameOverView {
            let view = GameOverView()
            view.isHidden = true
            return view
        }
    }

}

private extension NewGameView {

    struct AnimationsFactory {
        static func positionYButtonAnimation(frame: CGRect) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = (3*(frame.size.height/2))
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.fillMode = .backwards
            return animation
        }

        static func showGameOverAnimation() -> CATransition {
            let animation = CATransition()
            animation.type = .fade
            animation.duration = 0.5
            return animation
        }
    }

}

protocol NewGameViewDelegate: AnyObject {
    func didTapBackButton()
}
