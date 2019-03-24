import SpriteKit

class GameOverNode: SKSpriteNode {
    
    private var backButton: SKButton
    private var retryButton: SKButton
    
    init(with size: CGSize, score: Int?) {
        retryButton = SKButton(texture: SKTexture(imageNamed: "Retry"))
        retryButton.zPosition = 6
        retryButton.anchorPoint = .zero
        retryButton.sizeToFit(width: size.width / 2)
        retryButton.position = CGPoint(x: (size.width / 2) - (retryButton.size.width / 2), y: size.height * 0.3)
        
        backButton = SKButton(texture: SKTexture(imageNamed: "Back"))
        backButton.sizeToFit(width: size.width / 2)
        backButton.anchorPoint = CGPoint(x: 0, y: 1)
        backButton.position = CGPoint(x: retryButton.position.x, y: retryButton.frame.minY - 20)
        super.init(texture: SKTexture(imageNamed: "GameOver"), color: .clear, size: CGSize(width: size.width - 80, height: size.height * 4/6))
        self.size = size
        addChild(retryButton)
        addChild(backButton)
        
        anchorPoint = CGPoint(x: 0, y: 0)

        let gameOverLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.color = .red
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Wide")
        scoreLabel.fontSize = 120
        scoreLabel.text = "\(score ?? 0)"
        scoreLabel.position = CGPoint(x: size.width / 2, y: gameOverLabel.frame.maxY + 30)
        addChild(scoreLabel)
    }
    
    func setActions(for back: @escaping SKButtonAction, retry: @escaping SKButtonAction) {
        backButton.action = back
        retryButton.action = retry
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
