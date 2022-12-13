//
//  DataLoader.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import Foundation
class DataLoader {
    private let filename: String
    init(filename: String) {
        self.filename = filename
    }
    
    public func readLocalFile() -> [DemoDataPoints]? {
        var decodedData: [DemoDataPoints] = []
        do {
            if let bundlePath = Bundle.main.path(forResource: filename,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                decodedData = parse(jsonData: jsonData)
            }
        } catch {
            print(error)
            return nil
        }
        
        return decodedData
    }
    
    func loadPoints() -> [CGPoint] {
        var rawPoints = [CGPoint]()
        if let decodedPoints = readLocalFile() {
            for point in decodedPoints {
                rawPoints.append(CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
            }
        }
        return rawPoints
    }
    
    private func parse(jsonData: Data) -> [DemoDataPoints] {
        var decodedData: [DemoDataPoints] = []
        
        do {
            decodedData = try JSONDecoder().decode([DemoDataPoints].self,
                                                   from: jsonData)
            //print("data: ", decodedData)
            
        } catch (let error) {
            print("decode \(error)")
        }
        
        return decodedData
    }
}
