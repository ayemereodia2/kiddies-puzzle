//
//  DotPuzzle.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import Foundation
protocol ViewUpdaterDelegate: AnyObject {
    func updateViewController(dots: [Dot])
}

class DotPuzzle {
    weak var delegate: ViewUpdaterDelegate?
    
    public var connectedDots:[Dot] = [] {
        didSet {
            delegate?.updateViewController(dots: connectedDots)
        }
    }
    
    public var unconnectedDots:[Dot] = [] 
    
    private var points:[CGPoint]
    
    public init(points: [CGPoint]) {
        self.points = points
        makeUnconnectedDots()
    }
    
    func connectOneMoreDot() -> DotPuzzle {
        let firstUnconnectedDot = unconnectedDots.removeFirst()
        connectedDots.append(firstUnconnectedDot)
        return self
    }
    
      func makeUnconnectedDots() {
        for (index,point) in points.enumerated() {
            let unconnectedDot = Dot(location: point, label: index)
            unconnectedDots.append(unconnectedDot)
        }
    }
    
    func activateSubView() {
        delegate?.updateViewController(dots: unconnectedDots)
    }
}

struct Dot {
    var location:CGPoint
    var label:Int
}

struct DemoDataPoints: Codable {
    let x: Float
    let y: Float
}
