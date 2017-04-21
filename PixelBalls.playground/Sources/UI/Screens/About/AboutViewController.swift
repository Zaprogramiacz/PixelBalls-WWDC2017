import UIKit

public final class AboutViewController: UIViewController, AboutViewDelegate {

    private var viewControllerPresenter: Presenter

    public init(viewControllerPresenter: Presenter) {
        self.viewControllerPresenter = viewControllerPresenter
        super.init(nibName: nil, bundle: nil)
        self.viewControllerPresenter.viewController = self
        view = AboutView(delegate: self)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        aboutView.startAnimation()
    }

    var aboutView: AboutView! {
        return view as? AboutView
    }

    // MARK: AboutViewDelegate

    func didTapBackButton() {
        viewControllerPresenter.pop(viewController: self)
    }

}
