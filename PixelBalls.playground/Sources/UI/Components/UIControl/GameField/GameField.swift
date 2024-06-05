import UIKit

final class GameField: UIControl {

    typealias ButtonActionClosure = () -> ()
    var buttonActionClosure: ButtonActionClosure?

    override var isSelected: Bool {
        didSet {
            changeBackgroundColor()
        }
    }

    var ballImage: UIImage? {
        didSet {
            CATransaction.begin()
            ballImageView.layer.add(AnimationsFactory.createBallTransitionAnimation(), forKey: nil)
            ballImageView.image = ballImage
            CATransaction.commit()
        }
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        addSubviews()
        setupLayout()
        setupLayer()
        configureButtonAction()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Button action

    private func configureButtonAction() {
        addTarget(self, action: #selector(didTapOnButton), for: .touchUpInside)
    }

    @objc
    func didTapOnButton() {
        buttonActionClosure?()
    }

    // MARK: Layer

    private func setupLayer() {
        layer.cornerRadius = 6
        layer.borderWidth = 3
        layer.borderColor = UIColor.black.cgColor
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(ballImageView)
    }

    let ballImageView = UIImageView(frame: .zero)

    // MARK: Layout

    private func setupLayout() {
        setupBallImageViewLayout()
    }

    private func setupBallImageViewLayout() {
        ballImageView.translatesAutoresizingMaskIntoConstraints = false
        ballImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 7).isActive = true
        ballImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -7).isActive = true
        ballImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 7).isActive = true
        ballImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -7).isActive = true
        ballImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
        ballImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
    }

    // MARK: Helpers

    func showRedBackground() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.backgroundColor = .red
        }) { [weak self] _ in
            self?.backgroundColor = .white
        }
    }

    private func changeBackgroundColor() {
        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = self.isSelected ? self.selectedColor : .white
        }
    }

    private let selectedColor = UIColor(red: 0, green: 0.4118, blue: 0.5373, alpha: 1.0)

}

private extension GameField {

    struct AnimationsFactory {
        static func createBallTransitionAnimation() -> CATransition {
            let animation = CATransition()
            animation.duration = 0.3
            animation.type = .fade
            return animation
        }
    }

}
