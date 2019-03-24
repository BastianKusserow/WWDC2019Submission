import SpriteKit

class BaseScene: SKScene {
    
    private let towerL = SKSpriteNode(imageNamed: "GameTurm")
    private let towerR = SKSpriteNode(imageNamed: "GameTurm")
    let wall = SKSpriteNode(imageNamed: "Wall")
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundColor = UIColor(red: 209 / 255, green: 226 / 255, blue: 1, alpha: 1)
        setupTowers()
        setupWall()
        setupClouds()
    }
    
    private func setupTowers() {
        towerL.anchorPoint = .zero
        towerL.xScale = -0.2
        towerL.yScale = 0.25
        towerL.position = CGPoint(x: towerL.size.width / 2, y: 0)
        addChild(towerL)
        
        towerR.xScale = 0.2
        towerR.yScale = 0.25
        towerR.anchorPoint = .zero
        towerR.position = CGPoint(x: size.width - (towerR.size.width / 2), y: 0)
        addChild(towerR)
    }
    
    private func setupWall() {
        wall.size = CGSize(width: size.width, height: towerR.size.height / 2)
        let physicsBody = SKPhysicsBody(rectangleOf: wall.size, center: CGPoint(x: wall.size.width / 2, y: wall.size.height / 2))
        wall.physicsBody = physicsBody
        wall.physicsBody?.affectedByGravity = false
        wall.physicsBody?.isDynamic = false
        wall.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
        wall.physicsBody?.contactTestBitMask = CollisionTypes.ballon.rawValue
        wall.anchorPoint = .zero
        wall.position = CGPoint(x: 0, y: -wall.size.height / 2)
        addChild(wall)
    }
    
    private func setupClouds() {
        let cloud1Texture = SKTexture(imageNamed: "cloud1")
        let cloud2Texture = SKTexture(imageNamed: "cloud2")
        let cloud3Texture = SKTexture(imageNamed: "cloud3")
        
        let cloud1 = createCloud(with: cloud1Texture, at: CGPoint(x: size.width, y: wall.size.height - 10), movementDuration: 20)
        let cloud2 = createCloud(with: cloud2Texture, at: CGPoint(x: size.width, y: cloud1.frame.maxY), movementDuration: 25)
        let _ = createCloud(with: cloud3Texture, at: CGPoint(x: size.width, y: cloud2.frame.maxY), movementDuration: 20)
    }
    
    private func createCloud(with texture: SKTexture, at position: CGPoint, movementDuration duration: TimeInterval) -> SKSpriteNode {
        var cloud: SKSpriteNode!
        for i in 0 ... 1 {
            cloud = SKSpriteNode(texture: texture)
            addChild(cloud)
            cloud.anchorPoint = .zero
            cloud.zPosition = -1
            cloud.position = CGPoint(x: -CGFloat(i) * position.x, y: position.y)
            cloud.size.width = size.width
            cloud.yScale = cloud.xScale
            let moveLeft = SKAction.moveBy(x: cloud.size.width, y: 0, duration: duration)
            let moveReset = SKAction.moveBy(x: -cloud.size.width, y: 0, duration: 0)
            let moveLoop = SKAction.sequence([moveLeft, moveReset])
            let moveForever = SKAction.repeatForever(moveLoop)
            
            cloud.run(moveForever)
            
        }
        return cloud
    }
}
