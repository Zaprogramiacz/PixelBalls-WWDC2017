import UIKit

final public class BackgroundView: UIView {

    var balls: [PixelBallImageView] = []
    let numberOfBalls: Int

    public init(numberOfBalls: Int) {
        self.numberOfBalls = numberOfBalls
        super.init(frame: .zero)
        backgroundColor = UIColor.darkGray
        addSubviews()
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        let numberOfBallsAssets = Ball.allBalls.count
        for _ in 0...numberOfBalls {
            let assetNumber = Int.randomNumber(from: 0, to: numberOfBallsAssets-1)
            let asset = Ball.allBalls[assetNumber]
            let imageView = PixelBallImageView(asset: asset)
            balls.append(imageView)
            addSubview(imageView)
        }
    }

    // MARK: Animation

    public func resetAnimation() {
        balls.forEach { $0.removeFromSuperview() }
        balls = []
        addSubviews()
    }

    public func startAnimation() {
        for ball in balls {
            let width = bounds.width
            let height = bounds.height
            let positionX = Int.randomNumber(from: 0, to: Int(width))
            let positionY = Int.randomNumber(from: 0, to: Int(height))
            let size = Int.randomNumber(from: Int(0.04*width), to: Int(0.10*width))
            ball.bounds.size = CGSize(width: size, height: size)
            ball.center = CGPoint(x: positionX, y: positionY)
            ball.layer.add(growingAnimation(), forKey: nil)
        }
    }

    private func growingAnimation() -> CABasicAnimation {
        let duration = Int.randomNumber(from: 1, to: 4)
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = Double(duration)
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }
    
}
