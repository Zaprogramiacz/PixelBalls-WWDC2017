import UIKit

final class GameFieldViewModel {

    var ball: Ball? {
        didSet {
            if let ball = ball {
                let image = UIImage(asset: ball)
                ballChangedClosure?(image)
            } else {
                ballChangedClosure?(nil)
                isSelected = false
            }
        }
    }

    var isSelected = false {
        didSet {
            selectFieldClosure?(isSelected)
        }
    }

    var isFieldEmpty: Bool {
        return ball == nil ? true : false
    }

    var fieldWasChecked = false

    typealias BallChangedClosure = (_ ballImage: UIImage?) -> ()
    var ballChangedClosure: BallChangedClosure?

    typealias GameFieldDidSelectedClosure = (_ viewModel: GameFieldViewModel) -> ()
    var gameFieldDidSelectedClosure: GameFieldDidSelectedClosure?

    typealias SelectFieldClosure = (_ isSelected: Bool) -> ()
    var selectFieldClosure: SelectFieldClosure?

    typealias CannotMoveThereClosure = () -> ()
    var cannotMoveThereClosure: CannotMoveThereClosure?

    init() {  }

}
