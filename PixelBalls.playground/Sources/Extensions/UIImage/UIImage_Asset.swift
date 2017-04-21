import UIKit

extension UIImage {

    public convenience init?(asset: Showable) {
        self.init(named: asset.stringValue())
    }

}
