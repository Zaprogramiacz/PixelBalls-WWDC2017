import UIKit

public class NavigationController: UINavigationController {

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 450)
        setup()
    }

    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        setup()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        setNavigationBarHidden(true, animated: false)
    }

}
