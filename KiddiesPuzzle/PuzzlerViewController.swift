//
//  ViewController.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

class PuzzlerViewController: UIViewController {
    
    var dataloader: DataLoader = {
        DataLoader(filename: "star")
    }()
    
    var graphView:GraphView!
    var rawPoints = [CGPoint]()
    var nodeItems = [GraphItem]()
    var dotModels:DotPuzzle!
    var updatedSrc = CGPoint.zero
    public var scale : CGFloat = 0.9
    var w2 = 1000.0
    var h2 = 950.0
    var scaleController = ModelToViewCoordinates()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
        //self.view.addGestureRecognizer(pinchGesture)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let decodedPoints = dataloader.readLocalFile() {
            for point in decodedPoints {
                rawPoints.append(CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
            }
        }
        graphView = GraphView(frame: CGRect(x: 0, y: 0, width: w2, height: h2))
        graphView.delegate = self
        view.addSubview(graphView)
        
        dotModels = DotPuzzle(points: rawPoints)
        dotModels?.delegate = self
        dotModels.activateSubView()
        graphView.center = view.center
        
    }

    // take CGPoint JSON inputs from API or folder
    // pass points to initialize DotPuzzle models
    // reload GraphView with array of GraphItems
  
    
    private func updateUI(items: [GraphItem]) {
        graphView.items = items
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        dotModels.connectOneMoreDot()
    }
//    
//    @objc func changeScale(_ pinchRecognizer : UIPinchGestureRecognizer) {
//        switch pinchRecognizer.state {
//        case .changed, .ended:
//            scale = pinchRecognizer.scale
//            //scaleController = scaleController.scale(by: scale)
//            pinchRecognizer.view?.transform = (pinchRecognizer.view?.transform)!.scaledBy(x: pinchRecognizer.scale, y: pinchRecognizer.scale)
//            //dotModels.activateSubView()
//            pinchRecognizer.scale = 1.0
//        default:
//            break
//        }
//    }

}

extension PuzzlerViewController: ViewUpdaterDelegate {
    func activateUnconnectedDotsInSubView(dots: [Dot]) {
        var items:GraphItem!
        nodeItems = []
        for point in dots {
            let result = convertToView(point: point.location)

            if point.label == 0 {
                items = .node(loc: CGPoint(x: result.x, y: result.y), name: "", highlighted: true)
            } else {
                items = .node(loc: CGPoint(x: result.x, y: result.y), name: "", highlighted: false)
            }
            nodeItems.append(items)
        }
        
        updateUI(items: nodeItems)
    }
    
    func convertToView(point: CGPoint) -> CGPoint {
        scaleController.toView(modelPoint: point)
    }
    
    func activateConnectedDotsInSubView(dots: [Dot]) {
        guard let last = dots.last else { return }
       
       for point in dots {
        
        let items:GraphItem = .edge(src: CGPoint(x: updatedSrc.x, y: updatedSrc.y), dst: CGPoint(x: last.location.x, y: last.location.y), highlighted: true)
            nodeItems.append(items)
        }

        updateUI(items: nodeItems)
    }
}

extension PuzzlerViewController: SourcePointDelegate {
    func didUpdateSource(point: CGPoint) {
        self.updatedSrc = point
    }
}

/*
 
 @objc func changeScale(_ pinchRecognizer : UIPinchGestureRecognizer) {
     switch pinchRecognizer.state {
     case .changed, .ended:
         //scale *= pinchRecognizer.scale
     pinchRecognizer.view?.transform = (pinchRecognizer.view?.transform)!.scaledBy(x: pinchRecognizer.scale, y: pinchRecognizer.scale)
         //    sender.scale = 1.0
         pinchRecognizer.scale = 1.0
     default:
         break
     }
 }
 
 //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
 //self.view.addGestureRecognizer(pinchGesture)
 */
extension Float {
    func roundToFloat(_ fractionDigits: Int) -> Float {
        let multiplier = pow(10, Float(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
