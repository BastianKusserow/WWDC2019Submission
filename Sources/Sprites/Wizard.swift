import SpriteKit

class Wizard: SKSpriteNode {
    
    private var walkingFrames = [SKTexture]()
    
    
    init() {
        let texture = SKTexture(imageNamed: "wizard1")
        super.init(texture: texture, color: .clear, size: texture.size())
        
        setupWizard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupWizard() {
        var frames = [SKTexture]()
        
        for i in 1...4 {
            let name = "wizard\(i)"
            frames.append(SKTexture(imageNamed: name))
        }
        walkingFrames = frames
//        let targetWidth = size.width / 5
//        let upscaleFactor = targetWidth / wizard.size.height
//        wizard.size = CGSize(width: targetWidth, height: wizard.size.height * upscaleFactor)
//        wizard.anchorPoint = CGPoint(x: 0.5, y: 0)
//        wizard.position = CGPoint(x: 20, y: wall.frame.maxY - 12)
//        wizard.zPosition = 2
        
    }
    
    public func moveWizard(to point: CGPoint) {
        var multiplier: CGFloat
        if point.x < position.x {
            multiplier = 1.0
        } else {
            multiplier = -1.0
        }
        xScale = abs(xScale) * multiplier
        
        let move = SKAction.sequence([.move(to:  point, duration: 1.5), .run { [weak self] in self?.removeAllActions() }])
        let walking = SKAction.repeatForever(SKAction.animate(with: walkingFrames, timePerFrame: 0.1, resize: false, restore: true))
        run(move)
        run(walking)
    }
}

