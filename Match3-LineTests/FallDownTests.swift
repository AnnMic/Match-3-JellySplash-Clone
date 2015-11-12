//
//  FallDownTests.swift
//  Match3-Line
//
//  Created by Ann Michelsen on 06/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import UIKit
import XCTest

class FallDownTests: XCTestCase {
    var rows = 3
    var columns = 3
    var gameplay = GamePlay()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        gameplay.nbrOfRows = rows
        gameplay.nbrOfColums = columns
        
        var grid = Grid<Gem>(rows: rows, colums: columns)
        
        /*  O = gem x = empty
        X O O
        O X O
        X X X
        */
        
        grid[1,0] = Gem(row: 1, column: 0, gemType: GemType.Blue)
        grid[2,1] = Gem(row: 2, column: 1, gemType: GemType.Blue)
        grid[1,2] = Gem(row: 1, column: 2, gemType: GemType.Blue)
        grid[2,2] = Gem(row: 2, column: 2, gemType: GemType.Blue)
        
        gameplay.grid = grid
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRemoveGems() {
        /* result should be: O = gem, X = empty spot
        X X X
        X X O
        O O O
        */
        let gem = gameplay.grid[1,0]!
        gameplay.getFallingGems()
        
        XCTAssertNil(gameplay.grid[1,0], "should be nil, gem should have fallen down")
        XCTAssertNil(gameplay.grid[2,0], "should be nil, gem should have fallen down")
        XCTAssertNotNil(gameplay.grid[0,0], "should not be nil, gem should have filled spot")
        
        XCTAssertNil(gameplay.grid[1,1], "should be nil, gem should have filled spot")
        XCTAssertNil(gameplay.grid[2,1], "should be nil, gem should have filled spot")
        XCTAssertNotNil(gameplay.grid[0,1], "should not be nil, gem should have filled spot")
        
        XCTAssertNil(gameplay.grid[2,2], "should be nil, gem should have filled spot")
        XCTAssertNotNil(gameplay.grid[0,2], "should not be nil, gem should have filled spot")
        XCTAssertNotNil(gameplay.grid[1,2], "should not be nil, gem should have filled spot")
        
        XCTAssertEqual(gem.row, 0, "The gem was moved, should be 0")
        XCTAssertEqual(gem.column, 0, "The gem was moved, should be 0")
        
        
        
    }
}