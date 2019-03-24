import SpriteKit
import UIKit

public class MainViewController: UIViewController {
    
    public override var prefersStatusBarHidden: Bool { return true }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    
        let view = SKView()
        view.frame = CGRect(x: 0, y: 0, width: 375, height: 750)
        self.view = view
        let scene = StartScene()
        view.showsFPS = true
        scene.scaleMode = .resizeFill
        
        view.presentScene(scene)
    }
}
