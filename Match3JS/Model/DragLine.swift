//
//  DragLine.swift
//  Match3
//
//  Created by Ann Michelsen on 04/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import Foundation

//
// Struct that represent a line that is being draged
//

struct DragLine {
    var lineOrder: [Gem]
    var lastAddedGem: Gem!
    var previousGem: Gem?

    var uniqueGems: Set<Gem>

    init() {
        lineOrder = [Gem]()
        uniqueGems = Set()
    }

    mutating func addToLine(gem: Gem) {
        if !uniqueGems.contains(gem) {
            uniqueGems.insert(gem)
            lineOrder.append(gem)

            previousGem = lastAddedGem
            lastAddedGem = gem
        }
    }

    mutating func removeFromLine() {
        let positionToRemove = lineOrder.last!
        lineOrder.removeLast()
        uniqueGems.remove(positionToRemove)
        changeLastGems(previousGem!)
    }

    mutating func changeLastGems(gem: Gem) {
        lastAddedGem = gem
        if lineOrder.count == 1 {
            previousGem = nil
        }
        if lineOrder.count >= 2 {
            previousGem = lineOrder[lineOrder.endIndex - 2]
        }
    }

    mutating func removeAll() {
        previousGem = nil
        lastAddedGem = nil
        lineOrder.removeAll(keepCapacity: false)
        uniqueGems.removeAll()
    }

    func count() -> Int {
        return lineOrder.count
    }
}