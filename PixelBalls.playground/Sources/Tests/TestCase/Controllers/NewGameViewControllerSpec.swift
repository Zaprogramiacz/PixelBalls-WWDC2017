import XCTest

public class NewGameViewControllerSpec: XCTestCase {

    var presenterSpy: ViewControllerPresenterSpy!
    var sut: NewGameViewController!

    override public func setUp() {
        super.setUp()
        presenterSpy = ViewControllerPresenterSpy()
        sut = NewGameViewController(viewControllerPresenter: presenterSpy)
    }

    override public func tearDown() {
        super.tearDown()
        presenterSpy = nil
        sut = nil
    }

    func testUserTapOnBackButton() {
        sut.didTapBackButton()
        let didDismissNewGameViewController = presenterSpy.didDismissViewController?.isKind(of: NewGameViewController.self)
        XCTAssertTrue(didDismissNewGameViewController ?? false, "Dismissed view controller is NOT kind of NewGameViewController class")
    }
    
}
