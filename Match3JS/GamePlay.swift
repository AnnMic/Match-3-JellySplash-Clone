//
//  GamePlay.swift
//  Match3-Line
//
//  Created by Ann Michelsen on 06/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import Foundation

class GamePlay {

    var grid: Grid<Gem>!

    var poolOfGems = [Gem]() //Creates pool of gems that will be reused instead of creating new ones

    var lineBeingDraged: DragLine!

    var nbrOfRows: Int = 7
    var nbrOfColums: Int = 7

    init() {
        grid = Grid(rows: nbrOfRows, colums: nbrOfColums)
    }

    func createPoolOfGems() {
        var gem: Gem

        for row in 0 ..< nbrOfRows {
            for column in 0 ..< nbrOfColums {
                gem = Gem(row: row, column: column, gemType: GemType(rawValue: Int(arc4random_uniform(5)))!)
                grid[row, column] = gem
                poolOfGems.append(gem)
            }
        }
    }

    func getGem(row: Int, column: Int) -> Gem {
        return grid[row, column]!
    }

    func gemsToRemove() -> [Gem] {
        var gemsToRemove = [Gem]()
        for gem in lineBeingDraged.lineOrder {
            grid[gem.row, gem.column] = nil
            gem.row = -1
            gem.column = -1
            gemsToRemove.append(gem)

        }
        lineBeingDraged.removeAll()
        return gemsToRemove
    }

    func getFallingGems() -> [Gem] {
        var fallingGems = [Gem]()
        for row in 0 ..< nbrOfRows {
            for column in 0 ..< nbrOfColums {
                if grid[row, column] == nil {
                    // Found empty spot!
                    let fallingGem = fillEmptySlot(row, column: column)
                    fallingGems += fallingGem
                }
            }
        }
        return fallingGems
    }

    //Makes a gem fall down to the last empty spot
    private func fillEmptySlot(row: Int, column: Int) -> [Gem] {
        var fallingColumns = [Gem]()
        for nextRow in row + 1 ..< nbrOfRows {
            if grid[nextRow, column] != nil {
                //Found slot that includes a gem, dont need to go further down in the grid

                grid[row, column] = grid[nextRow, column] //move this gem down
                grid[nextRow, column] = nil //Set the previous spot to empty
                grid[row, column]!.row = row
                fallingColumns.append(grid[row, column]!)
                break;
            }
        }
        return fallingColumns
    }


    func addNewGems() -> [Gem] {
        var newGems = [Gem]()
        for column in 0 ..< nbrOfColums {
            for var row = nbrOfRows - 1; row > 0 && grid[row, column] == nil; row-- {
                let newColumns = addNewGem(row, column: column)
                newGems += newColumns
            }
        }
        return newGems
    }

    private func addNewGem(row: Int, column: Int) -> [Gem] {
        var newColumns = [Gem]()
        for gem in poolOfGems {
            if !gem.inUse() {
                gem.gemType = gem.randomGemType()
                gem.updateImage()
                gem.row = row
                gem.column = column
                grid[row, column] = gem
                newColumns.append(gem)
                break;
            }
        }
        return newColumns
    }
}