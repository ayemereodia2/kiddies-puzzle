//
//  DotPuzzle.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import Foundation
protocol ViewUpdaterDelegate: AnyObject {
    func activateUnconnectedDotsInSubView(dots: [Dot], with highlightedIndex: Int)
    func activateConnectedDotsInSubView(dots: [Dot])
}

class DotPuzzle {
    weak var delegate: ViewUpdaterDelegate?
    
    public var connectedDots:[Dot] = [] {
        didSet {
            activateSubView(activated: connectedDots.count)
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
        let firstUnconnectedDot = unconnectedDots.remove(at: 1) // [1,2,3]
        connectedDots.append(firstUnconnectedDot) // [1,2,3]
        return self
    }
    
      func makeUnconnectedDots() {
        for (index,point) in points.enumerated() {
            let unconnectedDot = Dot(location: CGPoint(x: point.x, y: point.y), label: index)
            unconnectedDots.append(unconnectedDot)
        }
    }
    
    func activateSubView(activated index: Int) {
        delegate?.activateUnconnectedDotsInSubView(dots: unconnectedDots, with: index)
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
