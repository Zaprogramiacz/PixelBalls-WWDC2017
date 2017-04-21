import XCTest

public class MainMenuViewControllerSpec: XCTestCase {

    var presenterSpy: ViewControllerPresenterSpy!
    var sut: MainMenuViewController!

    override public func setUp() {
        super.setUp()
        presenterSpy = ViewControllerPresenterSpy()
        sut = MainMenuViewController(viewControllerPresenter: presenterSpy)
    }

    override public func tearDown() {
        super.tearDown()
        presenterSpy = nil
        sut = nil
    }

    func testUserTapOnAboutButton() {
        sut.didTapAbout()
        let didPresentAboutViewController = presenterSpy.didPresentViewController?.isKind(of: AboutViewController.self)
        XCTAssertTrue(didPresentAboutViewController ?? false, "Presented view controller is NOT kind of AboutViewController class")
    }

    func testUserTapOnNewGameButton() {
        sut.didTapNewGame()
        let didPresentNewGameViewController = presenterSpy.didPresentViewController?.isKind(of: NewGameViewController.self)
        XCTAssertTrue(didPresentNewGameViewController ?? false, "Presented view controller is NOT kind of NewGameViewController class")
    }

}
