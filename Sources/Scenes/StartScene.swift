import UIKit
import SpriteKit

class StartScene: BaseScene {
    
    private let easyMode = SKButton(texture: SKTexture(imageNamed: "Easy"))
    private let hardMode = SKButton(texture: SKTexture(imageNamed: "Hard"))
    private let startButtonSprite = SKButton(texture: SKTexture(imageNamed: "Play"))
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)

        addChild(startButtonSprite)
        startButtonSprite.position = CGPoint(x: size.width / 2, y: size.height / 3)
        startButtonSprite.size = CGSize(width: size.width / 3, height: size.width / 3)
        startButtonSprite.action = changeScene(_:)
        
        setupSettings()
    }
    
    @objc
    private func changeScene(_ button: SKButton) {
        let scene = MainScene()
        scene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 0.5)
        view!.presentScene(scene, transition: transition)
    }
    
    private func setupSettings() {
        easyMode.anchorPoint = .zero
        hardMode.anchorPoint = .zero
        easyMode.sizeToFit(width: size.width / 3)
        hardMode.sizeToFit(width: size.width / 3)
        easyMode.position = CGPoint(x: easyMode.size.width / 3,
                                    y: startButtonSprite.frame.minY - 60)
        hardMode.position = CGPoint(x: easyMode.frame.maxX + easyMode.size.width / 3,
                                    y: startButtonSprite.frame.minY - 60)
        addChilds(easyMode, hardMode)
        hardMode.isSelected = Settings.shared.difficulty == .hard
        easyMode.isSelected = Settings.shared.difficulty == .easy
        easyMode.action = changeSelection(_:)
        hardMode.action = changeSelection(_:)
    }
    
    private func changeSelection(_ button: SKButton) {
        easyMode.isSelected = false
        hardMode.isSelected = false
        button.isSelected.toggle()
        Settings.shared.difficulty = easyMode.isSelected ? .easy : .hard
    }
    

}
