import AVFoundation

extension Game {

    func playSound() {
        if let soundURL = Bundle.main.url(forResource: "ball_sound", withExtension: "m4a") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound)
        }
    }

    func playPointsSound() {
        if let soundURL = Bundle.main.url(forResource: "beep_points", withExtension: "m4a") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound)
        }
    }

    func playCannotMoveSound() {
        if let soundURL = Bundle.main.url(forResource: "beep_cannot_move", withExtension: "m4a") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &mySound)
            AudioServicesPlaySystemSound(mySound)
        }
    }

}
