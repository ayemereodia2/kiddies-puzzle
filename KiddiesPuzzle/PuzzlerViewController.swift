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
    
    var graphView = GraphView()
    
    var rawPoints = [CGPoint]()
    var nodeItems = [GraphItem]()
    var dotModels:DotPuzzle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    // initialize GraphView with array of GraphItems
  
    
    private func updateUI(items: [GraphItem]) {
        graphView.items = items
    }
}

extension PuzzlerViewController: ViewUpdaterDelegate {
    func updateViewController(dots: [Dot]) {
        for point in dots {
            let items:GraphItem = .node(loc: CGPoint(x: point.location.x, y: point.location.y), name: "", highlighted: true)
            nodeItems.append(items)
        }
        
        updateUI(items: nodeItems)
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
