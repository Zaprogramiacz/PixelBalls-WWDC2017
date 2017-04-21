import UIKit

public final class NewGameViewController: UIViewController, NewGameViewDelegate {

    private var viewControllerPresenter: Presenter
    private let game: Game

    public init(viewControllerPresenter: Presenter) {
        self.viewControllerPresenter = viewControllerPresenter
        self.game = Game(size: 8)
        super.init(nibName: nil, bundle: nil)
        self.viewControllerPresenter.viewController = self
        view = NewGameView(delegate: self)
        setupClosures()
        game.startGame()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        newGameView.startAnimation()
    }

    var newGameView: NewGameView! {
        return view as? NewGameView
    }

    // MARK: Setup Closures

    private func setupClosures() {
        newGameView.gameFieldViewModels = game.gameFieldViewModels
        newGameView.nextBallViewModels = game.nextBallViewModels
        game.didUpdateScoreClosure = { [weak newGameView] score in
            newGameView?.score = score
        }
        game.gameOverClosure = { [weak newGameView] score in
            newGameView?.showGameOverView(score)
        }
        newGameView.gameOverView.completionClosure = { [weak viewControllerPresenter, weak self] in
            guard let `self` = self else { return }
            viewControllerPresenter?.pop(viewController: self)
        }
    }

    // MARK: NewGameViewDelegate

    func didTapBackButton() {
        viewControllerPresenter.pop(viewController: self)
    }

}
