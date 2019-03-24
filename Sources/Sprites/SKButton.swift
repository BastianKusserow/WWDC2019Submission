import SpriteKit

typealias SKButtonAction = (SKButton) -> Void

class SKButton: SKSpriteNode {
    
    var action: (SKButtonAction)?
    var isSelected: Bool = true {
        didSet {
            colorBlendFactor = isSelected ? 0 : 0.3
        }
    }
    
    init(texture: SKTexture) {
        let size = texture.size()
        super.init(texture: texture, color: .clear, size: size)
        isUserInteractionEnabled = true
        color = .black
        colorBlendFactor = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        alpha = 0.7
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        alpha = 1.0
        action?(self)
    }
}
