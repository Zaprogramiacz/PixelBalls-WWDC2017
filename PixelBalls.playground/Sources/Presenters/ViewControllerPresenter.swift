import UIKit

public protocol Presenter: class {
    var viewController: UIViewController? { get set }

    func push(viewController: UIViewController)
    func pop(viewController: UIViewController)
}

class ViewControllerPresenter: Presenter {

    weak var viewController: UIViewController?

    func push(viewController: UIViewController) {
        self.viewController?.navigationController?.pushViewController(viewController, animated: true)
    }

    func pop(viewController: UIViewController) {
        _ = self.viewController?.navigationController?.popViewController(animated: true)
    }

}
