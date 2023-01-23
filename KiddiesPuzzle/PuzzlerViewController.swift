//
//  ViewController.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

class PuzzlerViewController: UIViewController {
    
    var dataloader: DataLoader
    
    var graphView:GraphView = {
       return GraphView()
    }()
    
    var cancelButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "list.bullet.rectangle"), for: .normal)
        view.tintColor = .white
        return view
    }()
    
    var rawPoints = [CGPoint]()
    var nodeItems = [GraphItem]()
    var dotModels:DotPuzzle!
    var updatedSrc = CGPoint.zero
    public var scale : CGFloat = 0.9
    var maxX = 0.0
    var maxY = 0.0
    
    init(dataloader: DataLoader) {
        self.dataloader = dataloader
        super.init(nibName: nil, bundle: nil)
        if let decodedPoints = dataloader.readLocalFile() {
            for point in decodedPoints {
                if point.x > maxX {
                    maxX = point.x
                }
                
                if point.y > maxY {
                    maxY = point.y
                }
                
                rawPoints.append(CGPoint(x: CGFloat(point.x), y: CGFloat(point.y)))
            }
        }
        
        dotModels = DotPuzzle(points: rawPoints)
        dotModels?.delegate = self
        graphView = GraphView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        graphView.delegate = self
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            cancelButton.widthAnchor.constraint(equalToConstant: 44),
            cancelButton.heightAnchor.constraint(equalToConstant: 44),
            graphView.topAnchor.constraint(equalTo: cancelButton.bottomAnchor),
            graphView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            graphView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        cancelButton.addTarget(self, action: #selector(closePuzzler), for: .touchUpInside)
        dotModels.activateSubView(activated: 1)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        graphView.center = view.center
        graphView.action = {
            self.dotModels.connectOneMoreDot()
        }
        
        print(view.frame.size)
    }

    // take CGPoint JSON inputs from API or folder
    // pass points to initialize DotPuzzle models
    // reload GraphView with array of GraphItems
  
    
    private func updateUI(items: [GraphItem]) {
        graphView.items = items
    }
    
    private func updateUIForLines(items: [GraphItem]) {
        graphView.lineItems = items
    }

    @objc func closePuzzler() {
        dismiss(animated: true)
    }

}

extension PuzzlerViewController: ViewUpdaterDelegate {
    func activateUnconnectedDotsInSubView(dots: [Dot], with highlightedIndex: Int) {
        var items:GraphItem!
        let tempDots = dots
        if tempDots.isEmpty { return }
        
        let firstPoint = tempDots.startIndex
        let secondItem = tempDots.index(after: firstPoint)
        nodeItems = []
        for (index,point) in tempDots.enumerated() {
            if index == secondItem {
                items = .node(loc: CGPoint(x: point.location.x, y: point.location.y), name: "\(point.label)", highlighted: true)
            } else {
                items = .node(loc: CGPoint(x: point.location.x, y: point.location.y), name: "\(point.label)", highlighted: false)
            }
        
            nodeItems.append(items)
            
        }
        graphView.items = nodeItems
    }
    
    func activateConnectedDotsInSubView(dots: [Dot]) {
        guard let last = dots.last else { return }
           let items:GraphItem = .edge(
            src: CGPoint(x: updatedSrc.x, y: updatedSrc.y),
            dst: CGPoint(x: last.location.x, y: last.location.y),
            name: "\(last.label)",
            highlighted: true)
           graphView.items.append(items)
    }
}

extension PuzzlerViewController: SourcePointDelegate {
    func didUpdateSource(point: CGPoint) {
        self.updatedSrc = point
    }
}

extension Float {
    func roundToFloat(_ fractionDigits: Int) -> Float {
        let multiplier = pow(10, Float(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}
