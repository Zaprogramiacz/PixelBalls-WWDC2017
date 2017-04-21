import XCTest

public class AboutViewControllerSpec: XCTestCase {

    var presenterSpy: ViewControllerPresenterSpy!
    var sut: AboutViewController!

    override public func setUp() {
        super.setUp()
        presenterSpy = ViewControllerPresenterSpy()
        sut = AboutViewController(viewControllerPresenter: presenterSpy)
    }

    override public func tearDown() {
        super.tearDown()
        presenterSpy = nil
        sut = nil
    }

    func testUserTapOnBackButton() {
        sut.didTapBackButton()
        let didDismissAboutViewController = presenterSpy.didDismissViewController?.isKind(of: AboutViewController.self)
        XCTAssertTrue(didDismissAboutViewController ?? false, "Dismissed view controller is NOT kind of AboutViewController class")
    }
    
}
