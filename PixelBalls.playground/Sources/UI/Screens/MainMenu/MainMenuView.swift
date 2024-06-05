import UIKit

final class MainMenuView: UIView {

    private weak var delegate: MainMenuViewDelegate?

    init(delegate: MainMenuViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor.darkGray
        addSubviews()
        setupLayout()
        setupButtonActions()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Button actions

    private func setupButtonActions() {
        newGameButton.buttonActionClosure = { [weak self] in
            self?.delegate?.didTapNewGame()
        }
        aboutButton.buttonActionClosure = { [weak self] in
            self?.delegate?.didTapAbout()
        }
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(backgroundView)
        addSubview(titleContainer)
        addSubview(buttonsContainer)
        titleContainer.addSubview(titleImageView)
        buttonsContainer.addSubview(newGameButton)
        buttonsContainer.addSubview(aboutButton)
    }

    private let newGameButton = PixelButton(title: "New Game")
    private let aboutButton = PixelButton(title: "About")
    private let titleContainer = SubviewsFactory.createContriner()
    private let buttonsContainer = SubviewsFactory.createContriner()
    private let titleImageView = SubviewsFactory.createTitleImageView()
    private let backgroundView = BackgroundView(numberOfBalls: 35)

    // MARK: Layout

    private func setupLayout() {
        backgroundViewLayout()
        titleImageViewLayout()
        titleContainerLayout()
        buttonsContainerLayout()
        newGameButtonLayout()
        aboutButtonLayout()
    }

    private func backgroundViewLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func titleImageViewLayout() {
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleImageView.leadingAnchor.constraint(equalTo: titleContainer.layoutMarginsGuide.leadingAnchor).isActive = true
        titleImageView.topAnchor.constraint(equalTo: titleContainer.layoutMarginsGuide.topAnchor).isActive = true
        titleImageView.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor).isActive = true
        titleImageView.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor).isActive = true
    }

    private func titleContainerLayout() {
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        titleContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        titleContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        titleContainer.bottomAnchor.constraint(equalTo: buttonsContainer.topAnchor).isActive = true
        titleContainer.heightAnchor.constraint(equalTo: buttonsContainer.heightAnchor, multiplier: 0.5).isActive = true
    }

    private func buttonsContainerLayout() {
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonsContainer.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        buttonsContainer.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        buttonsContainer.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func newGameButtonLayout() {
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.centerXAnchor.constraint(equalTo: buttonsContainer.centerXAnchor).isActive = true
        newGameButton.topAnchor.constraint(equalTo: buttonsContainer.topAnchor, constant: 10).isActive = true
    }

    private func aboutButtonLayout() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        aboutButton.centerXAnchor.constraint(equalTo: buttonsContainer.centerXAnchor).isActive = true
        aboutButton.topAnchor.constraint(equalTo: newGameButton.bottomAnchor, constant: 10).isActive = true
    }

    // MARK: Animation

    func startAnimation() {
        showViewElements()
        backgroundView.startAnimation()
        newGameButton.layer.add(AnimationsFactory.positionYButtonAnimation(frame: frame), forKey: nil)
        newGameButton.layer.add(AnimationsFactory.opacityButtonAnimation(), forKey: nil)
        aboutButton.layer.add(AnimationsFactory.positionYButtonAnimation(frame: frame), forKey: nil)
        aboutButton.layer.add(AnimationsFactory.opacityButtonAnimation(), forKey: nil)
        titleImageView.layer.add(AnimationsFactory.scaleTitleImageAnimation(), forKey: nil)
    }

    public func resetAnimation() {
        hideViewElements()
        backgroundView.resetAnimation()
    }

    private func showViewElements() {
        titleImageView.isHidden = false
        newGameButton.isHidden = false
        aboutButton.isHidden = false
    }

    private func hideViewElements() {
        titleImageView.isHidden = true
        newGameButton.isHidden = true
        aboutButton.isHidden = true
    }

}

private extension MainMenuView {

    struct SubviewsFactory {
        static func createContriner() -> UIView {
            let view = UIView(frame: .zero)
            view.backgroundColor = .clear
            return view
        }

        static func createTitleImageView() -> UIImageView {
            let imageView = UIImageView(frame: .zero)
            imageView.image = UIImage(asset: Asset.title)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }

}

private extension MainMenuView {

    struct AnimationsFactory {
        static func positionYButtonAnimation(frame: CGRect) -> CABasicAnimation {
            let animation = CASpringAnimation(keyPath: "position.y")
            animation.fromValue = (3*(frame.size.height/2))
            animation.duration = 1.4
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.damping = 10
            animation.beginTime = CACurrentMediaTime() + 0.3
            animation.fillMode = .backwards
            return animation
        }

        static func opacityButtonAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.beginTime = CACurrentMediaTime() + 0.3
            animation.fillMode = .backwards
            return animation
        }

        static func scaleTitleImageAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 1
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            animation.beginTime = CACurrentMediaTime() + 0.2
            animation.fillMode = .backwards
            return animation
        }
    }

}

protocol MainMenuViewDelegate: AnyObject {
    func didTapNewGame()
    func didTapAbout()
}
