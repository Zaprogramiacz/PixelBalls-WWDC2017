import UIKit

public final class PixelButton: UIControl {

    typealias ButtonActionClosure = () -> ()
    var buttonActionClosure: ButtonActionClosure?

    public init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        backgroundColor = UIColor.white
        addSubviews()
        setupLayout()
        setupLayer()
        configureButtonAction()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
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
        layer.cornerRadius = 8
        layer.borderWidth = 4
        layer.borderColor = UIColor.black.cgColor
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(titleLabel)
    }

    private let titleLabel = Factory.createTitleLabel()

    // MARK: Layout

    private func setupLayout() {
        let margins = layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -15).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5).isActive = true
    }

}

private extension PixelButton {

    struct Factory {
        static func createTitleLabel() -> UILabel {
            let label = UILabel(frame: .zero)
            label.font = UIFont(name: Font.MGPixel, size: 40)
            return label
        }
    }

}
