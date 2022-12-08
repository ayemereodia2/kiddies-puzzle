//
//  ViewController.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

class PuzzlerViewController: UIViewController {
    
    var dataloader: DataLoader = {
        DataLoader(filename: "simple")
    }()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
        //self.view.addGestureRecognizer(pinchGesture)
    }
    
    var nodeItems = [GraphItem]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let decodedPoints = dataloader.readLocalFile() {
            for point in decodedPoints {
                let items:GraphItem = .node(loc: CGPoint(x: point.x, y: point.y), name: "", highlighted: true)
                nodeItems.append(items)
            }
            
            let graphView = GraphView()
            graphView.items = nodeItems
            graphView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(graphView)
            NSLayoutConstraint.activate([
                graphView.topAnchor.constraint(equalTo: view.topAnchor),
                graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
    }
    
    // take CGPoint JSON inputs from API or folder
    // pass points to initialize DotPuzzle models
    // initialize GraphView with array of GraphItems
    
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
}

