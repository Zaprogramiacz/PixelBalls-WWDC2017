import UIKit

class ViewControllerPresenterSpy: Presenter {

    var viewController: UIViewController?
    var didPresentViewController: UIViewController?
    var didDismissViewController: UIViewController?

    func push(viewController: UIViewController) {
        didPresentViewController = viewController
    }

    func pop(viewController: UIViewController) {
        didDismissViewController = viewController
    }

}
