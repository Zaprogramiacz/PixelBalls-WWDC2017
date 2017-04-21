import UIKit

public final class PixelTextView: UIView {

    public init(text: String?) {
        super.init(frame: .zero)
        textLabel.text = text
        setup()
        setupLayer()
        addSubviews()
        setupLayout()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setup() {
        backgroundColor = .white
        clipsToBounds = true
    }

    // MARK: Layer

    private func setupLayer() {
        layer.cornerRadius = 8
        layer.borderWidth = 4
        layer.borderColor = UIColor.black.cgColor
    }

    // MARK: Subviews

    private func addSubviews() {
        addSubview(textLabel)
    }

    let textLabel = SubviewsFactory.createTextLabel()

    // MARK: Layout

    private func setupLayout() {
        let margins = layoutMarginsGuide
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 5).isActive = true
        textLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 15).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -15).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -5).isActive = true
    }

}

private extension PixelTextView {

    struct SubviewsFactory {
        static func createTextLabel() -> UILabel {
            let label = UILabel(frame: .zero)
            label.font = UIFont(name: Font.MGPixel, size: 30)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }
    }

}
