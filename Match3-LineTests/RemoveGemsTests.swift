//
//  RemoveGemsTests.swift
//  Match3-Line
//
//  Created by Ann Michelsen on 06/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import UIKit
import XCTest

class RemoveGemsTests: XCTestCase {
    var rows = 2
    var columns = 2
    var gameplay = GamePlay()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        var line = DragLine()
        line.addToLine(Gem(row: 0, column: 0, gemType: GemType.Blue))
        line.addToLine(Gem(row: 0, column: 1, gemType: GemType.Blue))
        line.addToLine(Gem(row: 1, column: 1, gemType: GemType.Blue))
        gameplay.lineBeingDraged = line
        
        var grid = Grid<Gem>(rows: rows, colums: columns)
        for row in 0..<rows{
            for column in 0..<columns {
                grid[row,column] = Gem(row: row, column: column, gemType: GemType.Blue)
            }
        }
        gameplay.grid = grid
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveGems() {
        let gem = gameplay.grid[0,0]!
        gameplay.gemsToRemove()
        
        XCTAssertNil(gameplay.grid[0,0], "gem should had been removed")
        XCTAssertNil(gameplay.grid[0,1], "gem should had been removed")
        XCTAssertNil(gameplay.grid[1,1], "gem should had been removed")
        XCTAssertNotNil(gameplay.grid[1,0], "gem should not have been removed")
        
        XCTAssertEqual(gem.row, -1, "The gem was removed, should have -1 as row")
        
    }
}