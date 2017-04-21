import UIKit
import PlaygroundSupport

public class PixelBalls {

    private let page = PlaygroundPage.current

    public init() {
        Font.loadFonts()
        let presenter = ViewControllerPresenter()
        let mainMenuViewController = MainMenuViewController(viewControllerPresenter: presenter)
        let navigationController = NavigationController(rootViewController: mainMenuViewController)
        rootController = navigationController
        loadView()
    }

    private func loadView() {
        page.liveView = view
    }

    public var view: UIView {
        guard let view = self.rootController?.view else { fatalError() }
        return view
    }

    private var rootController: NavigationController?

}
