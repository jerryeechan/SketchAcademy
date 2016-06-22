//
//  BVHTest.swift
//  BVHTest
//
//  Created by jerry on 2016/5/11.
//  Copyright © 2016年 Jerry Chan. All rights reserved.
//

import XCTest
@testable import SwiftGL
class FakeStroke:HasBound  {
    var _rect:GLRect!
    var rect: GLRect{
        get{
            return _rect
        }
        set
        {
            _rect = newValue
        }
    }
    var data:Int!
    init(rect:GLRect,data:Int)
    {
        self.rect = rect
        self.data = data
    }
}
class BVHTest: XCTestCase {
    var strokes:[HasBound] = [FakeStroke]()
    let t = BVHTree()
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        var index = 0
        
            /*
            for j in 0...6
            {
                
                let leftTop = Vec2(x: random()%50,y: random()%50)
                
                strokes.append(FakeStroke(rect: GLRect(p1: leftTop,p2: leftTop+Vec2(1,1)), data: index))
                index += 1
            }*/
        strokes.append(FakeStroke(rect: GLRect(p1: Vec2(0,0),p2: Vec2(1,1)), data: 1))
        strokes.append(FakeStroke(rect: GLRect(p1: Vec2(2,0),p2: Vec2(3,1)), data: 2))
        strokes.append(FakeStroke(rect: GLRect(p1: Vec2(10,10),p2: Vec2(11,11)), data: 3))
        strokes.append(FakeStroke(rect: GLRect(p1: Vec2(12,10),p2: Vec2(13,11)), data: 4))
        
        
        t.buildTree(strokes)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(1,1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
