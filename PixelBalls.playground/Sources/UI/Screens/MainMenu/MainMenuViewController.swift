import UIKit

public final class MainMenuViewController: UIViewController, MainMenuViewDelegate {

    private var viewControllerPresenter: Presenter

    public init(viewControllerPresenter: Presenter) {
        self.viewControllerPresenter = viewControllerPresenter
        super.init(nibName: nil, bundle: nil)
        self.viewControllerPresenter.viewController = self
        view = MainMenuView(delegate: self)
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainMenuView.startAnimation()
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        mainMenuView.resetAnimation()
    }

    var mainMenuView: MainMenuView! {
        return view as? MainMenuView
    }

    // MARK: MainMenuViewDelegate

    func didTapNewGame() {
        let presenter = ViewControllerPresenter()
        let newGameViewController = NewGameViewController(viewControllerPresenter: presenter)
        viewControllerPresenter.push(viewController: newGameViewController)
    }

    public func didTapAbout() {
        let presenter = ViewControllerPresenter()
        let aboutViewController = AboutViewController(viewControllerPresenter: presenter)
        viewControllerPresenter.push(viewController: aboutViewController)
    }

}
