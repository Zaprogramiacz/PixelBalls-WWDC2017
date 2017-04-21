import UIKit

final class GameOverView: UIView {

    typealias CompletionClosure = () -> ()
    var completionClosure: CompletionClosure?

    init() {
        super.init(frame: .zero)
        backgroundColor = .gray
        setupLayer()
        addSubviews()
        setupLayout()
        setupButtonAction()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Actions

    private func setupButtonAction() {
        restartButton.buttonActionClosure = { [weak self] in
            self?.completionClosure?()
        }
    }

    // MARK: Layer

    private func setupLayer() {
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 4
        layer.cornerRadius = 8
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(restartButton)
        addSubview(gameOverTextView)
    }

    private let restartButton = PixelButton(title: "Restart")
    private let gameOverTextView = PixelTextView(text: "")

    // MARK: Layout

    private func setupLayout() {
        setupRestartButtonLayout()
        setupGameOverTextViewLayout()
    }

    private func setupRestartButtonLayout() {
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        restartButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        restartButton.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
        restartButton.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        restartButton.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
    }

    private func setupGameOverTextViewLayout() {
        gameOverTextView.translatesAutoresizingMaskIntoConstraints = false
        gameOverTextView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        gameOverTextView.leadingAnchor.constraint(greaterThanOrEqualTo: layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        gameOverTextView.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
        gameOverTextView.bottomAnchor.constraint(equalTo: restartButton.topAnchor, constant: -20).isActive = true
        gameOverTextView.centerXAnchor.constraint(equalTo: restartButton.centerXAnchor).isActive = true
        gameOverTextView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }

    // MARK: Helpers

    func updateScoreLabel(score: Int) {
        gameOverTextView.textLabel.text = "Game over \n Score: \(score)"
    }

}
