//
//  LineTests.swift
//  Match3-Line
//
//  Created by Ann Michelsen on 06/01/15.
//  Copyright (c) 2015 Ann Michelsen. All rights reserved.
//

import UIKit
import XCTest

class LineTests: XCTestCase {
    var line: DragLine!
    var row: Int!
    var column: Int!
    var gem: Gem!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        line = DragLine()
        row = 0
        column = 0
        gem = Gem(row: row, column: column, gemType: GemType.Blue)
        line.addToLine(gem)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }

    func testAddFirst() {
        XCTAssertEqual(line.lastAddedGem, gem, "Last added pos should be the same as lastPosition")
        XCTAssertNil(line.previousGem?.row, "Only one object in line, prevPos should be nil")
    }

    func testAddSecondObjectFirst() {
        let secondGem = Gem(row: 0, column: 1, gemType: GemType.Blue)
        line.addToLine(secondGem)

        XCTAssertEqual(line.lastAddedGem, secondGem, "Last added pos should be the same as lastPosition")

        XCTAssertEqual(line.previousGem!, gem, "Last added pos should be the same as lastPosition")
        XCTAssertTrue(line.count() == 2, "count is not correct for line")
    }

    func testRemoveFromLine() {
        let secondGem = Gem(row: 0, column: 1, gemType: GemType.Blue)
        line.addToLine(secondGem)

        line.removeFromLine()
        XCTAssertEqual(line.lastAddedGem, gem, "Last added pos should be the same as first object")
        XCTAssertNil(line.previousGem?.row, "Only one object in line, prevPos should be nil")
    }
}