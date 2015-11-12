//
// Created by Ann Michélsen on 12/11/15.
// Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import Foundation
import SpriteKit

class Line {
    var image: SKSpriteNode!

    init(lineBeingDraged: DragLine) {
        let lastGem = lineBeingDraged.lastAddedGem
        let prevGem = lineBeingDraged.previousGem!

        image = getImage(lastGem,prevGem: prevGem)

        let row = Double(lastGem.row + prevGem.row) / 2
        let column = Double(lastGem.column + prevGem.column) / 2

        let position = CGPoint(x: CGFloat(column) * 50 + 50 / 2,
                y: CGFloat(row) * 50 + 50 / 2)

        image.position = position
    }

    func getImage(lastGem: Gem, prevGem: Gem) -> SKSpriteNode {
        let diffRow = lastGem.row - prevGem.row
        let diffColumn = lastGem.column - prevGem.column

        let fileName = "Line_\(diffRow)\(diffColumn)"

        return SKSpriteNode(imageNamed: fileName)
    }

    func animateLine() {
        let scale = SKAction.scaleTo(0.8, duration: 0)
        let color = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 0.4, duration: 0.1)
        let fade = SKAction.fadeOutWithDuration(2)

        image.runAction(SKAction.sequence([scale, color, fade, SKAction.removeFromParent()]))
    }

}
