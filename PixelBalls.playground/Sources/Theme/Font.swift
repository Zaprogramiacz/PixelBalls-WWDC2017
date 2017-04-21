import UIKit

public enum Font {
    static var MGPixel = "MGPixelFont"

    public static func loadFonts() {
        let fontURL = Bundle.main.url(forResource: "MGPixelFont", withExtension: "otf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
    }
}
