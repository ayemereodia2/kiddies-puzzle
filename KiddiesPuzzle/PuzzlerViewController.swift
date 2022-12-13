//
//  ViewController.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

class PuzzlerViewController: UIViewController {
    
    var dataloader: DataLoader = {
        DataLoader(filename: "tree")
    }()
    
    var graphView = GraphView()
    var rawPoints = [CGPoint]()
    var nodeItems = [GraphItem]()
    var dotModels:DotPuzzle!
    var updatedSrc = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        graphView.delegate = self
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let decodedPoints = dataloader.readLocalFile() {
            for point in decodedPoints {
                rawPoints.append(CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
            }
        }
        
        dotModels = DotPuzzle(points: rawPoints)
        dotModels?.delegate = self
        dotModels.activateSubView()
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        NSLayoutConstraint.activate([
            graphView.topAnchor.constraint(equalTo: view.topAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
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

}

extension PuzzlerViewController: ViewUpdaterDelegate {
    func activateUnconnectedDotsInSubView(dots: [Dot]) {
        var items:GraphItem!
        
        for point in dots {
            if point.label == 0 {
                 items = .node(loc: CGPoint(x: point.location.x, y: point.location.y), name: "", highlighted: true)
            } else {
                 items = .node(loc: CGPoint(x: point.location.x, y: point.location.y), name: "", highlighted: false)
            }
            nodeItems.append(items)
        }
        
        updateUI(items: nodeItems)
    }
    
    func activateConnectedDotsInSubView(dots: [Dot]) {
        guard let last = dots.last else { return }
        print(dots)
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
