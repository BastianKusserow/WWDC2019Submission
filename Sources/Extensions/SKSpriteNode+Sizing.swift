import SpriteKit

extension SKSpriteNode {
    
    func sizeToFit(width: CGFloat) {
        let upscaleFactor = width / size.width
        self.size = CGSize(width: width, height: size.height * upscaleFactor)
    }
}
