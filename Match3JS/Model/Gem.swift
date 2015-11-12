import SpriteKit

enum GemType: Int {
    case Blue
    case Green
    case Pink
    case White
    case Yellow
}

class Gem: CustomStringConvertible, Hashable {
    var row: Int
    var column: Int

    var image: SKSpriteNode!
    var gemType: GemType


    init(row: Int, column: Int, gemType: GemType) {
        self.row = row
        self.column = column
        self.gemType = gemType
        image = updateImage()
    }

    func updateImage() -> SKSpriteNode {
        let image = SKSpriteNode(imageNamed: "block\(gemType.rawValue)")
        image.runAction(SKAction.scaleTo(0.9, duration: 0))
        return image
    }

    func inUse() -> Bool {
        return row != -1
    }

    var description: String {
        return "type:\(gemType.rawValue) square:(\(row),\(column))"
    }

    func randomGemType() -> GemType {
        return GemType(rawValue: Int(arc4random_uniform(5)))!
    }

    func selectAnimation() {
        let action = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 0.6, duration: 0.1)
        image.runAction(action)
    }

    func unSelectAnimation() {
        let action = SKAction.colorizeWithColor(UIColor.blackColor(), colorBlendFactor: 0.0, duration: 0.1)
        image.runAction(action)
    }

    func removeGemAnimation() {
        let moveDuration = Double(arc4random_uniform(1) + 1) //TODO should be depending on the distance it needs to travel

        let move = SKAction.moveTo(CGPoint(x: image.position.x, y: -200), duration: moveDuration)

        let randomRotation = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let randomDuration = Double(arc4random_uniform(4))

        let rotate = SKAction.rotateByAngle(randomRotation, duration: randomDuration)
        let group = SKAction.group([move, rotate])
        let sequence = SKAction.sequence([group, SKAction.removeFromParent()])
        image.runAction(sequence)
    }

    func fallDownAnimation(newPosition: CGPoint) {
        let duration = 0.2
        let delayDuration = 0.1 * Double(row)

        let delay = SKAction.waitForDuration(delayDuration)
        let fallDown = SKAction.moveTo(newPosition, duration: duration)
        let sequence = SKAction.sequence([delay, fallDown])
        image.runAction(sequence)
    }

    func resetPositionAndGem(newPosition: CGPoint) {
        image = updateImage()
        image.position = newPosition
    }

    var hashValue: Int {
        return "\(self.row),\(self.column)".hashValue
    }
}

func ==(lhs: Gem, rhs: Gem) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}