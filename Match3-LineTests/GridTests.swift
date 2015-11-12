//
//  GridTests.swift
//  Match3-Line
//
//  Created by Ann Michelsen on 06/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import UIKit
import XCTest

class GridTests: XCTestCase {
    
    var grid : Grid<Int>!
    var rows = 2
    var columns = 2
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        grid = Grid(rows: rows, colums: columns)
        for row in 0..<rows{
            for column in 0..<columns {
                grid[row,column] = row + column
            }
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInsert(){
        XCTAssertEqual(grid[1,1]!, 2, "Insert is not correct for grid, should be 2 is: \(grid[1,1])")
    }
}