import Foundation
import SpriteKit

class Balloon: SKSpriteNode {
    
    let calculationResult: Int
    private var label: SKLabelNode = {
        return SKLabelNode(fontNamed: "AvenirNext-Bold")
    }()
    
    init() {
        let size = CGSize(width: 70, height: 100)
        let texture = SKTexture(imageNamed: "Ballon1")
        let max = Settings.shared.difficulty == .easy ? 9 : 99
        calculationResult = Int.random(in: 0...max)
        super.init(texture: texture, color: UIColor.clear, size: size)

        let physicsBody = SKPhysicsBody(texture: texture, size: size)
        physicsBody.affectedByGravity = false
        physicsBody.collisionBitMask = 0
        physicsBody.fieldBitMask = FieldTypes.gravityField.rawValue
        physicsBody.contactTestBitMask = CollisionTypes.wall.rawValue
        physicsBody.categoryBitMask = CollisionTypes.ballon.rawValue
//        physicsBody.collisionBitMask = UInt32(4)
//        physicsBody.fieldBitMask = UInt32(1)
//        physicsBody.contactTestBitMask = UInt32(5)
//        physicsBody.categoryBitMask = UInt32(0)
        self.physicsBody = physicsBody
        
        let firstNumber = Int.random(in: 0...calculationResult)
        label.text = "\(firstNumber)+\(calculationResult - firstNumber)"
        adjustLabelFontSizeToFitRect(labelNode: label, rect: frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)))
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func adjustLabelFontSizeToFitRect(labelNode:SKLabelNode, rect:CGRect) {
        let scalingFactor = min(rect.width / labelNode.frame.width, rect.height / labelNode.frame.height)
        labelNode.fontSize *= scalingFactor
        
        labelNode.position = CGPoint(x: rect.midX, y: rect.midY + (labelNode.frame.height / 4))
    }
}
