//
//  ModelToViewCoordinates.swift
//  KiddiesPuzzle
//
//  Created by ANDELA on 13/12/2022.
//

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
    var zoomScale: CGFloat
    
    // The point where the origin in Model Coordinates appears in
    // View Coordinates
    var viewOffset: CGPoint
    
    // Abstaction Function
    
    // Rep Invariant
    var modelBounds: CGRect?
    var viewBounds: CGRect?
    
    
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
        // TODO: Write me
        self.init(zoomScale: 1.0, viewOffset: CGPoint.zero)
        self.modelBounds = modelBounds
        self.viewBounds = viewBounds
    }
    
    /**
     
     TODO: Add specification
     
     - Parameter modelPoint: The location to convert, in model coordinates.
     - Returns: the modelPoint translated into view coordinates.
     */
    public func toView(modelPoint: CGPoint) -> CGPoint  {
        CGPoint(x: (modelPoint.x * self.zoomScale) + self.viewOffset.x, y: (modelPoint.y * self.zoomScale) + self.viewOffset.y)
    }
    
    /**
     
     TODO: Add specification
     
     - Parameter viewPoint: The location to convert, in view coordinates.
     - Returns: the viewPoint translated into model coordinates.
     */
    public func fromView(viewPoint: CGPoint) -> CGPoint  {
        return CGPoint(x: (viewPoint.x - self.viewOffset.x) / self.zoomScale, y: (viewPoint.y - self.viewOffset.y) / self.zoomScale)
    }
    
    /**
     
     TODO: Add specification
     
     - Parameter by: How much to change the zoomScale
     
     - Returns: a new ModelToViewCoordinates with the same
     viewOffset but a scale of self.zoomScale * amount
     */
    public mutating func scale(by amount: CGFloat) -> ModelToViewCoordinates  {
        self.zoomScale = self.zoomScale * CGFloat(Float(amount).roundToFloat(2))
        return self
    }
    
    /**
     
     TODO: Add specification
     
     - Parameter by: How much to change the viewOffset
     
     - Returns: a new ModelToViewCoordinates with the same
     zoomScale but an offset of (viewOffset.x + amount.x, viewOffset.y + amount.y)
     */
    public mutating func shift(by amount: CGPoint) -> ModelToViewCoordinates  {
        self.viewOffset = CGPoint(x: viewOffset.x + amount.x, y: viewOffset.y + amount.y)
        return self
    }
}
