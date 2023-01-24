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
}


class GraphView: UIView {
    var items: [GraphItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var scaleController: ModelToViewCoordinates = ModelToViewCoordinates() {
        didSet {
          self.layer.sublayers?.removeAll()
          setNeedsDisplay()
        }
    }
    
    public var scale : CGFloat = 0.9
    
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
    
    weak var delegate: SourcePointDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveView))
        let pincGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(pincGesture)
        backgroundColor = .cyan
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for item in items {
            switch item {
            case .node(loc: let loc, name: let centerText, highlighted: let highlighted):
                  let viewPoints = scaleController.toView(modelPoint: loc)
                src = viewPoints
                makeNodeCircle(point: viewPoints, name: centerText, highlighted: highlighted)
            case .edge(src: let src, dst: let des, name: let name, highlighted: let highlighted):
                  let viewPointsStart = scaleController.toView(modelPoint: src)
                  let viewPointsEnd = scaleController.toView(modelPoint: des)
                addLine(fromPoint: viewPointsStart, centerText: name, toPoint: viewPointsEnd, highlighted: highlighted)
            }
        }
    }

    var pointInBlue:(CGPoint) = (CGPoint(x: 0.0, y: 0.0))
    var currentValue = ""
    private func makeNodeCircle(point: CGPoint, name: String, highlighted: Bool) {
        let circleLayer = CAShapeLayer()
        let textLayer = CATextLayer()
        
        
        let ptx = convert(CGRect(x: point.x , y: point.y , width: 30, height: 30), to: self)
        let path = UIBezierPath(ovalIn: ptx )
        let color: UIColor = highlighted ? .blue : .yellow
        if highlighted {
            currentValue = name
        }
        
        circleLayer.lineWidth = 1
        circleLayer.strokeColor = UIColor.green.cgColor
        circleLayer.fillColor = color.cgColor
        circleLayer.path = path.cgPath
        textLayer.frame = convert(CGRect(x: point.x + 8.0 , y: point.y + 8.0 , width: 30, height: 30), to: self)
        textLayer.fontSize = 12
        textLayer.string = name
        textLayer.foregroundColor = UIColor.red.cgColor
        circleLayer.addSublayer(textLayer)
        layer.addSublayer(circleLayer)
    }
    
    private func animateConnecting(from start: CGPoint, to end: CGPoint) {
        let lineLayer = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: start.x + 20.0, y: start.y + 20.0))
        linePath.addLine(to: CGPoint(x: end.x + 20.0, y: end.y + 20.0))
        linePath.lineCapStyle = .butt
        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.lineWidth = 3
        lineLayer.lineJoin = CAShapeLayerLineJoin.round
        layer.addSublayer(lineLayer)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        lineLayer.add(animation, forKey: "MyAnimation")
    }
    
    private func addLine(fromPoint start: CGPoint, centerText: String = "", toPoint end:CGPoint, highlighted: Bool) {
        if highlighted {
            makeNodeCircle(point: end, name: centerText, highlighted: !highlighted)
            src = end
        }
        
        animateConnecting(from: start, to: end)
  }
    
    @objc func changeScale(_ pinchRecognizer : UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            //let zoomScale = pinchRecognizer.scale
            pinchRecognizer.view?.transform = (pinchRecognizer.view?.transform)!.scaledBy(x: pinchRecognizer.scale, y: pinchRecognizer.scale)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first, let touchedLayer = self.layerFor(touch), let text = touchedLayer.string as? String {
            if text == currentValue {
                action?()
            }
        }
    }
    
    private func layerFor(_ touch: UITouch) -> CATextLayer? {
        let touchLocation = touch.location(in: self)
        let locationInView = self.convert(touchLocation, to: nil)

        let hitPresentationLayer = layer.presentation()?.hitTest(locationInView)
        return hitPresentationLayer?.model() as? CATextLayer
    }
}

