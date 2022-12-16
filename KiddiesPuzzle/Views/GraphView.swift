//
//  GraphView.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 08/12/2022.
//

import UIKit

enum GraphItem {
    case node(loc: CGPoint, name: String, highlighted: Bool)
    case edge(src: CGPoint, dst: CGPoint, name: String, highlighted: Bool)
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
    
    var lineItems: [GraphItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    var action:(() -> Void)?
    var itemsPaths: [CGPoint] = []
    
    var src: CGPoint = CGPoint.zero {
        didSet {
            delegate?.didUpdateSource(point: src)
        }
    }
    var zoomScale: CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var shapeLayer = CAShapeLayer()

    weak var delegate: SourcePointDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveView))
        let pincGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
       // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pincGesture)
        //self.addGestureRecognizer(tapGesture)
        backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for (index,item) in items.enumerated() {
            
            switch item {
            case .node(loc: let loc, name: let centerText, highlighted: let highlighted):
                if index == 0 {
                    src = loc
                }
                makeNodeCircle(point: loc, name: centerText, highlighted: highlighted)
            case .edge(src: _, dst: _, name: _, highlighted: _):
                print("")
            }
        }
        
        for (index,item) in lineItems.enumerated() {
            switch item {
            case .edge(src: let src, dst: let des, name: let name, highlighted: let highlighted):
                addLine(fromPoint: src, centerText: name, toPoint: des, highlighted: highlighted)
            case .node(loc: _, name: _, highlighted: _):
                print("")
            }
        }
    }

    
    private func makeNodeCircle(point: CGPoint, name: String, highlighted: Bool) {
        let circleLayer = CAShapeLayer()
        let scale = UIScreen.main.scale
        let ptx = CGRect(x: point.x +  60.0 , y: point.y, width: 60, height: 60)
        let path = UIBezierPath(ovalIn: ptx )
        let color: UIColor = highlighted ? .blue : .yellow
        circleLayer.lineWidth = 1
        circleLayer.strokeColor = UIColor.green.cgColor
        circleLayer.fillColor = color.cgColor
        circleLayer.path = path.cgPath
        circleLayer.name = name
        self.layer.addSublayer(circleLayer)
    }
    
    private func addLine(fromPoint start: CGPoint, centerText: String = "", toPoint end:CGPoint, highlighted: Bool) {
        if highlighted {
            makeNodeCircle(point: end, name: centerText, highlighted: highlighted)
            makeNodeCircle(point: start, name: centerText, highlighted: !highlighted)
            src = end
        }
        let screen = UIScreen.main.scale
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: start.x + 80, y: start.y + 10))
        linePath.addLine(to: CGPoint(x: end.x  + 80, y: end.y + 10))
        linePath.lineCapStyle = .butt
        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 3
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
            zoomScale *= pinchRecognizer.scale
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
            let translation = gesture.translation(in: gesture.view)
            let changeX = (gesture.view?.center.x)! + translation.x
            let changeY = (gesture.view?.center.y)! + translation.y
            gesture.view?.center = CGPoint(x: changeX, y: changeY)
            gesture.setTranslation(CGPoint.zero, in: gesture.view)

        }
    }
    
    @objc func tapDetected(tapGesture: UITapGestureRecognizer) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//           guard let point = touch?.location(in: self) else { return }
//        if shapeLayer.path!.contains(point) {
//
//        }
        action?()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first
//        guard let point = touch?.location(in: self) else { return }
//        guard let sublayers = self.layer.sublayers as? [CAShapeLayer] else { return }
//
//        for layer in sublayers {
//            if layer.name == "0" {
//                print("layer")
//            }
//        }
//    }
}

