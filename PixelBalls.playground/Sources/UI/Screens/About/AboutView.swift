import UIKit

public final class AboutView: UIView {

    private weak var delegate: AboutViewDelegate?

    init(delegate: AboutViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
        backgroundColor = UIColor.darkGray
        addSubviews()
        setupLayout()
        setupButtonActions()
        hideElements()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
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
        addSubview(backButton)
        addSubview(infoView)
    }

    private let backgroundView = BackgroundView(numberOfBalls: 35)
    private let backButton = PixelButton(title: "Back")
    private let infoView = PixelTextView(text: "Code and\nDesign \nMaciej Gomolka")

    // MARK: Layout

    private func setupLayout() {
        setupBackgroundViewLayout()
        setupBackButtonLayout()
        setupInfoLabelLayout()
    }

    private func setupBackgroundViewLayout() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
    }

    private func setupBackButtonLayout() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
    }

    private func setupInfoLabelLayout() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }

    // MARK: Animation

    func startAnimation() {
        showElements()
        backgroundView.startAnimation()
        backButton.layer.add(AnimationsFactory.positionYButtonAnimation(frame: frame), forKey: nil)
        infoView.layer.add(AnimationsFactory.positionYTextViewAnimation(frame: frame), forKey: nil)
        infoView.layer.add(AnimationsFactory.transformTextViewAnimation(), forKey: nil)
    }

    private func showElements() {
        backButton.isHidden = false
        infoView.isHidden = false
    }

    private func hideElements() {
        backButton.isHidden = true
        infoView.isHidden = true
    }

}

private extension AboutView {

    struct AnimationsFactory {
        static func positionYButtonAnimation(frame: CGRect) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = (3*(frame.size.height/2))
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeBackwards
            return animation
        }

        static func positionYTextViewAnimation(frame: CGRect) -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.fromValue = frame.height/4
            animation.duration = 2
            return animation
        }

        static func transformTextViewAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "transform.scale")
            animation.fromValue = 0
            animation.toValue = 1
            animation.duration = 2
            return animation
        }
    }

}

protocol AboutViewDelegate: class {
    func didTapBackButton()
}
