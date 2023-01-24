//
//  KiddiesPuzzleTests.swift
//  KiddiesPuzzleTests
//
//  Created by ANDELA on 08/12/2022.
//

import XCTest
@testable import KiddiesPuzzle

final class KiddiesPuzzleTests: XCTestCase {

    func testToView() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint.zero ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 200.0, y: 200.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 0.0, y: 200.0) ),
          ( CGPoint(x: 0.0, y: -100.0),   CGPoint(x: 0.0, y: -200.0) ) ]
        
        var transform = ModelToViewCoordinates()
        transform = transform.scale(by: 2.0)
        transform = transform.shift(by: CGPoint.zero)
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.toView(modelPoint: modelPoint), viewPoint)
        }
      }
      
      func testFromView() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint.zero ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 200.0, y: 200.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 0.0, y: 200.0) ),
          ( CGPoint(x: 0.0, y: -100.0),   CGPoint(x: 0.0, y: -200.0) ) ]
        
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 2.0)
          transform = transform.shift(by: CGPoint.zero)
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.fromView(viewPoint: viewPoint), modelPoint)
        }
      }
      
      func testToViewWithOffset() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint(x: 10.0, y: 50.0) ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 110.0, y: 150.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 10.0, y: 150.0) ),
          ( CGPoint(x: 0.0, y: -100.0),  CGPoint(x: 10.0, y: -50.0) ) ]
                  
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 1)
          transform = transform.shift(by: CGPoint(x:10, y:50))
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.toView(modelPoint: modelPoint), viewPoint)
        }
      }
      
      func testFromViewWithOffset() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint(x: 10.0, y: 50.0) ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 110.0, y: 150.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 10.0, y: 150.0) ),
          ( CGPoint(x: 0.0, y: -100.0),  CGPoint(x: 10.0, y: -50.0) ) ]
                  
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 1)
          transform = transform.shift(by: CGPoint(x:10, y:50))
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.fromView(viewPoint: viewPoint), modelPoint)
        }
      }
      
      func testGrowAndOffset() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint(x: 10.0, y: 50.0) ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 210.0, y: 250.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 10.0, y: 250.0) ),
          ( CGPoint(x: 0.0, y: -100.0),  CGPoint(x: 10.0, y: -150.0) ) ]
                  
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 2)
          transform = transform.shift(by: CGPoint(x:10, y:50))
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.toView(modelPoint: modelPoint), viewPoint)
        }
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.fromView(viewPoint: viewPoint), modelPoint)
        }
      }
      
      func testShrinkAndOffset() {
        let modelViewPairs = [
          ( CGPoint.zero,                CGPoint(x: 10.0, y: 50.0) ),
          ( CGPoint(x: 100.0, y: 100.0), CGPoint(x: 60.0, y: 100.0) ),
          ( CGPoint(x: 0.0, y: 100.0),   CGPoint(x: 10.0, y: 100.0) ),
          ( CGPoint(x: 0.0, y: -100.0),  CGPoint(x: 10.0, y: 0.0) ) ]
        
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 0.5)
          transform = transform.shift(by: CGPoint(x:10, y:50))
          
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.toView(modelPoint: modelPoint), viewPoint)
        }
        
        for (modelPoint, viewPoint) in modelViewPairs {
          XCTAssertEqual(transform.fromView(viewPoint: viewPoint), modelPoint)
        }
      }
      
      
      func testScaleBy() {
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 2.0)
          transform = transform.shift(by: CGPoint(x:10, y:10))
        XCTAssertEqual(transform.scale(by: 2.0).zoomScale, 4.0)
        XCTAssertEqual(transform.scale(by: 2.0).viewOffset, transform.viewOffset)
        XCTAssertEqual(transform.scale(by: 0.5).zoomScale, 1.0)
        XCTAssertEqual(transform.scale(by: 0.5).viewOffset, transform.viewOffset)
      }
      
      func testShiftBy() {
          var transform = ModelToViewCoordinates()
          transform = transform.scale(by: 2.0)
          transform = transform.shift(by: CGPoint(x:10, y:10))
        XCTAssertEqual(transform.shift(by: CGPoint(x: 50, y: 100)).zoomScale, 2.0)
        XCTAssertEqual(transform.shift(by: CGPoint(x: 50, y: 100)).viewOffset, CGPoint(x:60, y: 110))
        XCTAssertEqual(transform.shift(by: CGPoint(x: -50, y: -100)).zoomScale, 2.0)
        XCTAssertEqual(transform.shift(by: CGPoint(x: -50, y: -100)).viewOffset, CGPoint(x:-40, y:-90))
      }
      
      func testBounds() {
        let b1 = CGRect(x: 0, y: 0, width: 400, height: 200)//vb
        let b2 = CGRect(x: 0, y: 0, width: 200, height: 100)
        let b3 = CGRect(x: 0, y: 0, width: 200, height: 50)
        let b4 = CGRect(x: -1, y: -1, width: 2, height: 2)//mb
        
        let t1 = ModelToViewCoordinates(modelBounds: b1, viewBounds: b2)
        XCTAssertEqual(t1.zoomScale, 0.5)
        XCTAssertEqual(t1.viewOffset, CGPoint.zero)

          let t2 = ModelToViewCoordinates(modelBounds: b1, viewBounds: b3)
        XCTAssertEqual(t2.zoomScale, 0.25)
        XCTAssertEqual(t2.viewOffset, CGPoint(x: 50, y: 0))
        
          let t3 = ModelToViewCoordinates(modelBounds: b4, viewBounds: b1)
        XCTAssertEqual(t3.zoomScale, 100.0)
        XCTAssertEqual(t3.viewOffset, CGPoint(x: 200, y: 100))
        
          let t4 = ModelToViewCoordinates(modelBounds: b4, viewBounds: b3)
        XCTAssertEqual(t4.zoomScale, 25.0)
        XCTAssertEqual(t4.viewOffset, CGPoint(x: 100, y: 25.0))
      }

}
