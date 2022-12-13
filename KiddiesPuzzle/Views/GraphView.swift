//
//  GraphView.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

enum GraphItem {
    case node(loc: CGPoint, name: String, highlighted: Bool)
    case edge(src: CGPoint, dst: CGPoint, highlighted: Bool)
}

protocol SourcePointDelegate: AnyObject {
    func didUpdateSource(point: CGPoint)
    //func didTap(point: CGPoint)
}


class GraphView: UIView {
    var items: [GraphItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var itemsPaths: [UIBezierPath] = []
    
    var src: CGPoint = CGPoint.zero {
        didSet {
            delegate?.didUpdateSource(point: src)
        }
    }
    
    weak var delegate: SourcePointDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveView))
        let pincGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))

        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pincGesture)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for (index,item) in items.enumerated() {
            
            switch item {
            case .node(loc: let loc, name: _, highlighted: let highlighted):
                if index == 0 {
                    src = loc
                }
                makeNodeCircle(point: loc, highlighted: highlighted)
            case .edge(src: let src, dst: let des, highlighted: let highlighted):
                addLine(fromPoint: src, toPoint: des, highlighted: highlighted)
            }
        }
    }
    
    private func makeNodeCircle(point: CGPoint, name: String = "", highlighted: Bool) {
        itemsPaths = []
        var path = UIBezierPath()
        path = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 20, height: 20))
        let color: UIColor = highlighted ? .blue : .yellow
        UIColor.green.setStroke()
        color.setFill()
        path.lineWidth = 2
        path.stroke()
        path.fill()
    }
    
    private func addLine(fromPoint start: CGPoint, toPoint end:CGPoint, highlighted: Bool) {
        if highlighted {
            makeNodeCircle(point: end, highlighted: highlighted)
            makeNodeCircle(point: start, highlighted: !highlighted)
            src = end
        }
        
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        linePath.lineCapStyle = .butt
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        layer.addSublayer(line)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        line.add(animation, forKey: "MyAnimation")
  }
    
    @objc func changeScale(_ pinchRecognizer : UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            let scale = pinchRecognizer.scale
            //scaleController = scaleController.scale(by: scale)
            pinchRecognizer.view?.transform = (pinchRecognizer.view?.transform)!.scaledBy(x: pinchRecognizer.scale, y: pinchRecognizer.scale)
            //dotModels.activateSubView()
            pinchRecognizer.scale = 1.0
        default:
            break
        }
    }
    
    @objc func moveView(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began  || gesture.state == .changed {
            var translation = gesture.translation(in: gesture.view)
            let changeX = (gesture.view?.center.x)! + translation.x
            let changeY = (gesture.view?.center.y)! + translation.y
            gesture.view?.center = CGPoint(x: changeX, y: changeY)
            gesture.setTranslation(CGPoint.zero, in: gesture.view)

        }
    }
}

