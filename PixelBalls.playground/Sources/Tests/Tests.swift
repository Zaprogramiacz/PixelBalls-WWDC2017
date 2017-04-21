import Foundation

public class Tests {

    public init() {
        MainMenuViewControllerSpec.defaultTestSuite().run()
        AboutViewControllerSpec.defaultTestSuite().run()
        NewGameViewControllerSpec.defaultTestSuite().run()
        Int_RandomNumberSpec.defaultTestSuite().run()
        GameSpec.defaultTestSuite().run()
    }

}
