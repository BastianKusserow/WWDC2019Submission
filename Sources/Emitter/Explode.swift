import SpriteKit

class Explode: SKEmitterNode {
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        particleTexture = SKTexture(imageNamed: "spark")
        numParticlesToEmit = 256
        
        particleBirthRate = 2048.0
        
        particleLifetime = 0.6
        emissionAngleRange = 360
        speed = 200
        yAcceleration = -500
        particleSpeedRange = 200
        particleAlpha = 0.8
        particleAlphaRange = 0.2
        particleAlphaSpeed = -1.4
        particleScale = 0.15
        particleColorBlendFactor = 1.0
        particleBlendMode = .add
        particleColorRedRange = 187
        particleColorGreenRange = 100
        particleColorBlueRange = 26
        particleColor = .orange
        zPosition = 10
    }
}
