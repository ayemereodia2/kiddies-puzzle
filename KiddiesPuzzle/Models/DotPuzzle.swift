//
//  DotPuzzle.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import Foundation

struct DotPuzzle {
    public var connectedDots:[Dot] = []
    public var unconnectedDots:[Dot] = []
    private var points:[CGPoint]
    
    public init(points: [CGPoint]) {
        self.points = points
        makeUnconnectedDots()
    }
    
    mutating func connectOneMoreDot() -> DotPuzzle {
        let firstUnconnectedDot = unconnectedDots.removeFirst()
        connectedDots.append(firstUnconnectedDot)
        return self
    }
    
     mutating func makeUnconnectedDots() {
        for (index,point) in points.enumerated() {
            let unconnectedDot = Dot(location: point, label: index)
            unconnectedDots.append(unconnectedDot)
        }
    }
}

struct Dot {
    var location:CGPoint
    var label:Int
}

struct DemoDataPoints: Codable {
    let x: Int
    let y: Int
}
