import SpriteKit

extension SKScene {
    
    func addChilds(_ childs: SKNode...) {
        for child in childs {
            addChild(child)
        }
    }
    
}
