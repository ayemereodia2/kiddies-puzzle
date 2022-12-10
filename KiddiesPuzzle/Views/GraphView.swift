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

@IBDesignable
class GraphView: UIView {
    var items: [GraphItem] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(changeScale))
        self.addGestureRecognizer(pinchGesture)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var scale : CGFloat = 0.9 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @objc func changeScale(_ pinchRecognizer : UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            //pinchRecognizer.scale = 1
            pinchRecognizer.view?.transform = (pinchRecognizer.view?.transform)!.scaledBy(x: pinchRecognizer.scale, y: pinchRecognizer.scale)
                //    sender.scale = 1.0
                pinchRecognizer.scale = 1.0
        default:
            break
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        for item in items {
            switch item {
            case .node(loc: let loc, name: _, highlighted: _):
                makeNodeCircle(point: loc)
            case .edge(src: _, dst: _, highlighted: _):
                print("")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = touches.first?.location(in: nil) else { return }
    
    }
    
    private func makeNodeCircle(point: CGPoint, name: String = "") {
        var path = UIBezierPath()
        //(x * scale + vx, y * scale + vy)
        path = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 20, height: 20))
        UIColor.yellow.setStroke()
        UIColor.red.setFill()
        path.lineWidth = 2
        path.stroke()
        path.fill()
    }
    
    private func addLine(fromPoint start: CGPoint, toPoint end:CGPoint) {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        linePath.lineCapStyle = .butt
        line.path = linePath.cgPath
        line.strokeColor = UIColor.yellow.cgColor
        line.lineWidth = 1
        line.lineJoin = CAShapeLayerLineJoin.round
        layer.addSublayer(line)
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.duration = 0.5
        line.add(animation, forKey: "MyAnimation")
  }
}



import Foundation
import CoreGraphics

/**
 A structure to help us convert between two coordinate systems.
 Points in "Model Coordinates" are zoomed and shifted to
 produce points in "View Coordinates".
 
 The **abstract state** for a conversion is:

  * zoomScale: the scale facter when going from model to view.
  * viewOffset: where the original in model coordinates appears
  in view coordinates.

 **Abstraction Invariant**: zoomScale > 0

*/
public struct ModelToViewCoordinates {

  // MARK: - Internal representation

  // Note that the folowing two properties should really be private, but I
  // have left them be the default internal access level so that they can
  // be accessed in the unit tests.

  // The scale factor applied to Model Coordinates when
  // converting to View Coordinates
  let zoomScale: CGFloat
  
  // The point where the origin in Model Coordinates appears in
  // View Coordinates
  let viewOffset: CGPoint

  // Abstaction Function

  // Rep Invariant


  
  // A private initializer for use in the public initializers
  // and methods.
  private init(zoomScale: CGFloat, viewOffset: CGPoint) {
    self.zoomScale = zoomScale
    self.viewOffset = viewOffset
  }

  /**
   
   **Effects**: Creates a new ModelToViewCoordinates object for the unit transform
   (zoomScale == 1, viewOffset == (0,0)).
   
   */
  public init() {
    self.init(zoomScale: 1.0, viewOffset: CGPoint.zero)
  }

  /**
   
   Create a transformation that maps the points inside the
   modelBounds rectangle to the greatest possible area inside
   of the viewBounds rectangle.  Examples:
   
   ```
   let b1 = CGRect(x: 0, y: 0, width: 400, height: 200)
   let b2 = CGRect(x: 0, y: 0, width: 200, height: 100)
   
   ModelToViewCoordinates(modelBounds: b1, viewBounds: b2)
   is the same as
   ModelToViewCoordinates(zoomScale: 0.5, viewOffset: CGPoint.zero)
   
   let b3 = CGRect(x: 0, y: 0, width: 200, height: 50)
   
   ModelToViewCoordinates(modelBounds: b1, viewBounds: b3)
   is the same as
   ModelToViewCoordinates(zoomScale: 0.25, viewOffset: CGPoint(x: 50, y: 0))
   ```
   
   **Requires**: modelBounds and viewBounds have width > 0 and height > 0.

   - Parameter modelBounds: A rectangle in model coordinates.
   - Parameter viewBounds: The rectangle in view coordinates that we wish
   to include all of the points in modelBounds.
   
   */
  public init(modelBounds: CGRect, viewBounds: CGRect) {
    // TODO: Write me.
    self.init(zoomScale: 1.0, viewOffset: CGPoint.zero)
  }
  
  /**

  TODO: Add specification

   - Parameter modelPoint: The location to convert, in model coordinates.
   - Returns: the modelPoint translated into view coordinates.
   */
  public func toView(modelPoint: CGPoint) -> CGPoint  {
    // TODO: Write me.
    return CGPoint.zero
  }
  
  /**

  TODO: Add specification

   - Parameter viewPoint: The location to convert, in view coordinates.
   - Returns: the viewPoint translated into model coordinates.
   */
  public func fromView(viewPoint: CGPoint) -> CGPoint  {
    // TODO: Write me.
    return CGPoint.zero
  }
  
  /**

  TODO: Add specification

   - Parameter by: How much to change the zoomScale
   
   - Returns: a new ModelToViewCoordinates with the same
     viewOffset but a scale of self.zoomScale * amount
   */
  public func scale(by amount: CGFloat) -> ModelToViewCoordinates  {
    // TODO: Write me.
    return self
  }
  
  /**

    TODO: Add specification

   - Parameter by: How much to change the viewOffset
   
   - Returns: a new ModelToViewCoordinates with the same
     zoomScale but an offset of (viewOffset.x + amount.x, viewOffset.y + amount.y)
   */
  public func shift(by amount: CGPoint) -> ModelToViewCoordinates  {
    // TODO: Write me.
    return self
  }
}
