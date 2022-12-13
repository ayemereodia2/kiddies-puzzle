//
//  DotPuzzle.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import Foundation
protocol ViewUpdaterDelegate: AnyObject {
    func activateUnconnectedDotsInSubView(dots: [Dot])
    func activateConnectedDotsInSubView(dots: [Dot])
}

class DotPuzzle {
    weak var delegate: ViewUpdaterDelegate?
    
    public var connectedDots:[Dot] = [] {
        didSet {
            delegate?.activateConnectedDotsInSubView(dots: connectedDots)
        }
    }
    
    public var unconnectedDots:[Dot] = [] 
    
    private var points:[CGPoint]
    
    public init(points: [CGPoint]) {
        self.points = points
        makeUnconnectedDots()
    }
    
    @discardableResult func connectOneMoreDot() -> DotPuzzle? {
        if unconnectedDots.isEmpty { return nil }
        let firstUnconnectedDot = unconnectedDots.removeFirst()
        connectedDots.append(firstUnconnectedDot)
        return self
    }
    
      func makeUnconnectedDots() {
        for (index,point) in points.enumerated() {
            let unconnectedDot = Dot(location: CGPoint(x: point.x, y: point.y), label: index)
            unconnectedDots.append(unconnectedDot)
        }
    }
    
    func activateSubView() {
        delegate?.activateUnconnectedDotsInSubView(dots: unconnectedDots)
    }
}

struct Dot {
    var location:CGPoint
    var label:Int
}

struct DemoDataPoints: Codable {
    let x: Double
    let y: Double
}
