import SpriteKit

class MainScene: BaseScene, ClassificationResultDelegate {
    
    // MARK: Scene items
    private let currentLabelNode = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    private let wizard = Wizard()
    private let scoreLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")
    private let linearGravity = SKFieldNode.linearGravityField(withVector: vector_float3(0, -0.1, 0))
    
    
    private var ballonNodes = Set<Balloon>()
    private let classifier: NumberClassifier
    private let drawView: DrawView
    private var current = ""
    private var predict = true
    
    
    override init(size: CGSize) {
        self.drawView = DrawView()
        self.classifier = NumberClassifier(drawView)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        self.drawView = DrawView()
        self.classifier = NumberClassifier(drawView)
        super.init()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setup()
        setupScene()
    }

    private func setup() {
        let group = SKAction.sequence([
            SKAction.run { [weak self] in self?.spawnNewBallon() },
            SKAction.wait(forDuration: 5)
            ])
        
        let action = SKAction.repeatForever(group)
        run(action)
        
        guard let view = view else { return }
        view.addSubview(drawView)
        drawView.backgroundColor = UIColor.gray.withAlphaComponent(0.05)
        drawView.pinHorizontal(to: view)
        drawView.isHidden = false
        classifier.delegate = self
    }
    
    private func setupScene() {
        physicsWorld.contactDelegate = self
        addChild(linearGravity)

        currentLabelNode.fontSize = 100.0
        currentLabelNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(currentLabelNode)

        setupWizard()
        setupScoreLabel()
    }
    
    private func setupScoreLabel() {
        scoreLabel.fontSize = 40.0
        scoreLabel.position = CGPoint(x: size.width / 2, y: 20)
        scoreLabel.zPosition = 4
        scoreLabel.text = "\(0)"
        addChild(scoreLabel)
    }
    
    private func setupWizard() {
        addChild(wizard)
        wizard.sizeToFit(width: size.width / 5)
        wizard.anchorPoint = CGPoint(x: 0.5, y: 0)
        wizard.position = CGPoint(x: 20, y: wall.frame.maxY - 12)
        wizard.zPosition = 2
        
    }
    
    private func moveWizard(_ position: CGPoint) {
        guard !isPaused, !wizard.hasActions() else { return }
        let target = CGPoint(x: position.x, y: wizard.position.y)
        wizard.moveWizard(to: target)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        guard let first = touches.first, predict else { return }
        moveWizard(first.location(in: view))

        let hitView = view!.hitTest(first.location(in: view!), with: event)
        if hitView === drawView {
            predict = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.predict = true
                self?.classifier.predictNumber()
            }
        }
    }
    
    func didClassificationRequest(with results: [Int]) {
        guard !results.isEmpty else { return }
        drawView.clear()
        let expectedNumbers = ballonNodes.map({ "\($0.calculationResult)" })

        var potentialResults = [String]()

        results.forEach { result in
            potentialResults += expectedNumbers.filter { $0.hasPrefix("\(current)\(result)") }
        }

        if !potentialResults.isEmpty {
            current = "\(current)\(potentialResults.first!)"
            currentLabelNode.fontColor = .white
            currentLabelNode.text = current
            removeNodes(ballonNodes.filter { "\($0.calculationResult)" == current })
        } else {
            currentLabelNode.fontColor = .red
            currentLabelNode.text = "\(current)\(results.first!)"
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.currentLabelNode.text = ""
                self?.current = ""
            }
        }
    }

    private func removeNodes(_ nodes: [Balloon]) {
        nodes.forEach {
            let explode = Explode()
            explode.position = $0.position
            addChild(explode)
            
            $0.removeFromParent()
            ballonNodes.remove($0)
            
            updateScore()
        }
    }
    
    private func updateScore() {
        current = ""
        currentLabelNode.text = ""
        scoreLabel.text = "\(Int(scoreLabel.text!)! + 1)"
    }

    private func spawnNewBallon() {
        let balloon = Balloon()
        let screenWidth = size.width - balloon.size.width / 2
        let spawnXCoordinate = CGFloat.random(in: balloon.size.width ... screenWidth)

        balloon.position = CGPoint(x: spawnXCoordinate, y: size.height + balloon.size.height)
        addChild(balloon)
        ballonNodes.insert(balloon)
    }
    
    private func showGameOver() {
        self.physicsWorld.speed = 0
        drawView.isUserInteractionEnabled = false
        drawView.isHidden = true
        
        let gameOver = GameOverNode(with: CGSize(width: size.width - 80, height: size.height * 4/6),
                                    score: Int(scoreLabel.text!))
        gameOver.position = CGPoint(x: 40, y: size.height * 1/6)
        gameOver.zPosition = 5
        
        gameOver.setActions(for: { [weak self] _ in
            let startScene = StartScene()
            startScene.scaleMode = .resizeFill
            self?.view?.presentScene(startScene)
        }, retry: restartGame(_:))
        addChild(gameOver)
    }
    
    private func restartGame(_ button: SKButton) {
        let scene = MainScene()
        scene.scaleMode = .resizeFill
        let transaction = SKTransition.fade(withDuration: 0.5)
        view?.presentScene(scene, transition: transaction)
    }
}

extension MainScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.contactTestBitMask == CollisionTypes.ballon.rawValue && contact.bodyB.categoryBitMask == CollisionTypes.ballon.rawValue) ||
            (contact.bodyB.contactTestBitMask == CollisionTypes.wall.rawValue && contact.bodyA.categoryBitMask == CollisionTypes.wall.rawValue) {
            showGameOver()
        }
    }
}
