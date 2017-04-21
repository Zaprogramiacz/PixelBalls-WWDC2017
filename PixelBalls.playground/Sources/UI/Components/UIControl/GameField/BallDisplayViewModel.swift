import UIKit

final class BallDisplayViewModel {

    var ball: Ball? {
        didSet {
            if let ball = ball {
                let image = UIImage(asset: ball)
                ballChangedClosure?(image)
            } else {
                ballChangedClosure?(nil)
            }
        }
    }

    typealias BallChangedClosure = (_ ballImage: UIImage?) -> ()
    var ballChangedClosure: BallChangedClosure?

    init() {  }

}
