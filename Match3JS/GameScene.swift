//
//  GameScene.swift
//  Match3JS
//
//  Created by Ann Michelsen on 05/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var lineBeingDraged: DragLine!

    var gemLayer = SKNode()
    var lineLayer = SKNode()
    var bgLayer = SKNode()

    var gameplay: GamePlay!

    var tileSize = CGSize(width: 50, height: 50)
    var startGemType: GemType?

    var handleLine: ((DragLine) -> ())?
    var lineSprites = [SKSpriteNode]()

    override init(size: CGSize) {
        super.init(size: size)

        lineBeingDraged = DragLine()

        addChild(bgLayer)

        lineLayer.position = CGPoint(x: 10, y: 150)
        addChild(lineLayer)

        gemLayer.position = CGPoint(x: 10, y: 150)
        addChild(gemLayer)

        addParticlesForBackground()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSpritesForGems(gems: [Gem]) {
        for gem in gems {
            gem.image = gem.updateImage()

            gem.image.position = pointsForGem(gem.row, column: gem.column)
            gemLayer.addChild(gem.image)
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch: AnyObject in touches {
            let point = touch.locationInNode(gemLayer)
            let (insideGrid, row, column) = isPointInsideGrid(point)

            if insideGrid {
                let gem = gameplay.getGem(row, column: column)
                startGemType = gem.gemType
                lineBeingDraged.addToLine(gem)
                gem.selectAnimation()
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

        if lineBeingDraged.lastAddedGem == nil {
            return
        }

        for touch: AnyObject in touches {
            let point = touch.locationInNode(gemLayer)
            let (insideGrid, row, column) = isPointInsideGrid(point)

            if (insideGrid) {
                let gem = gameplay.getGem(row, column: column)
                let gemType = gem.gemType

                if gem == lineBeingDraged.lastAddedGem || gemType != startGemType || !neighborToLastGem(gem.row, column: gem.column) {
                    return
                }
                if gem == lineBeingDraged.previousGem {
                    // Moving backwards
                    lineBeingDraged.lastAddedGem.unSelectAnimation()
                    gem.unSelectAnimation()
                    lineBeingDraged.removeFromLine()
                    removeOneLinePart()
                } else {
                    lineBeingDraged.addToLine(gem)
                    gem.selectAnimation()
                    addLine()
                }
            }
        }
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if lineBeingDraged.count() >= 3 {
            handleLine!(lineBeingDraged)
        } else {
            removeGemHighlight()
        }
        removeLine()

        lineBeingDraged.removeAll()
        startGemType = nil
    }

    func neighborToLastGem(row: Int, column: Int) -> Bool {
        let diffRow = lineBeingDraged.lastAddedGem.row - row
        let diffColumn = lineBeingDraged.lastAddedGem.column - column

        return (diffRow == 0 || diffRow == 1 || diffRow == -1) && (diffColumn == 0 || diffColumn == 1 || diffColumn == -1)
    }

    func isPointInsideGrid(point: CGPoint) -> (insideGrid:Bool, row:Int, column:Int) {
        if point.x >= 0 && point.x < (CGFloat(gameplay.nbrOfColums) * tileSize.width) {
            if point.y >= 0 && point.y < (CGFloat(gameplay.nbrOfRows) * tileSize.height) {

                let row = Int(point.y / tileSize.height)
              //  row = row < 0 ? 0 : row
                //row = row > nbrOfRows ? nbrOfRows : row

                let column = Int(point.x / tileSize.width)
                //column = column < 0 ? 0 : column
               // column = column > nbrOfColums ? nbrOfColums : column

                return (true, row, column)
            }
        }
        return (false, -1, -1)
    }

    func pointsForGem(row: Int, column: Int) -> CGPoint {
        return CGPoint(x: CGFloat(column) * tileSize.height + tileSize.height / 2,
                y: CGFloat(row) * tileSize.width + tileSize.width / 2)
    }

    func addParticlesForBackground() {
        let particles = SKEmitterNode(fileNamed: "MyParticle")!
        particles.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        bgLayer.addChild(particles)
    }

    func addLine() {
        let line = Line(lineBeingDraged: lineBeingDraged)
        lineLayer.addChild(line.image)
        lineSprites.append(line.image)
        line.animateLine()
    }

    func removeOneLinePart() {
        let lastLine = lineSprites.last!
        lastLine.removeFromParent()
    }

    func removeLine() {
        lineLayer.removeAllChildren()
        lineSprites.removeAll(keepCapacity: false)
    }

    func removeGemHighlight() {
        for gem in lineBeingDraged.lineOrder {
            gem.unSelectAnimation()
        }
    }

    func animateGemsBeingRemoved(gemsToRemove: [Gem], completion: () -> ()) {
        for gem in gemsToRemove {
            gem.removeGemAnimation()
        }

        let delayAction = SKAction.waitForDuration(1.5)
        runAction(delayAction, completion: completion)
    }

    func animateGemsFallingDown(fallingGems: [Gem], completion: () -> ()) {
        for gem in fallingGems {
            gem.fallDownAnimation(pointsForGem(gem.row, column: gem.column))
        }

        let delay = SKAction.waitForDuration(1.0)
        runAction(delay, completion: completion)
    }

    func animateAddNewGems(newGems: [Gem]) {
        for gem in newGems {
            gem.resetPositionAndGem(pointsForGem(gameplay.nbrOfRows, column: gem.column))
            gemLayer.addChild(gem.image)
        }
    }
}
