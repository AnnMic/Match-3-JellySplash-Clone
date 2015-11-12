import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var gamePlay: GamePlay!
    var movesLeft = 30

    @IBOutlet weak var moves: UILabel!
    @IBOutlet weak var score: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        let skView = view as! SKView
        skView.multipleTouchEnabled = false

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.showsDrawCount = true

        scene = GameScene(size: skView.bounds.size)
        // scene.scaleMode = .AspectFill
        scene.scaleMode = SKSceneScaleMode.ResizeFill


        skView.presentScene(scene)

        self.gamePlay = GamePlay()
        scene.gameplay = self.gamePlay
        scene.handleLine = handleMatch

        addGems()
        updateLabel()
    }

    func addGems() {
        gamePlay.createPoolOfGems()
        scene.addSpritesForGems(gamePlay.poolOfGems)
    }

    //This function handles what should happen when the user have done a valid drag
    func handleMatch(line: DragLine) {
        view.userInteractionEnabled = false
        gamePlay.lineBeingDraged = line

        let gemsToRemove = self.gamePlay.gemsToRemove()

        scene.animateGemsBeingRemoved(gemsToRemove) {
        }

        var fallingGems = self.gamePlay.getFallingGems()
        let newGems = self.gamePlay.addNewGems()

        self.scene.animateAddNewGems(newGems)

        fallingGems += newGems

        self.scene.animateGemsFallingDown(fallingGems) {
            self.nextDrag()
        }
    }

    func nextDrag() {
        view.userInteractionEnabled = true
        movesLeft--
        if movesLeft == 0 {
            gameOver()
        }
        updateLabel()
    }

    func updateLabel() {
        moves.text = "\(movesLeft)"
    }

    func gameOver() {
        scene.animateGemsBeingRemoved(gamePlay.poolOfGems) {
            self.restartGame()
        }
    }

    func restartGame() {
        self.gamePlay.poolOfGems.removeAll(keepCapacity: true)
        self.addGems()
        movesLeft = 30
        updateLabel()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
