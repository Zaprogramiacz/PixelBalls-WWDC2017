import UIKit

public final class PixelBallImageView: UIImageView {

    init(asset: Showable) {
        super.init(frame: .zero)
        image = UIImage(asset: asset)
        contentMode = .scaleAspectFit
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
