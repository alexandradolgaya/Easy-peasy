//
//  DashedView.swift
//  pingget
//
//  Created by Victor on 20.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class DashedView: UIView {

    @IBInspectable
    var dashColor : UIColor = UIColor.black
    
    @IBInspectable
    var fullDashed : Bool = false
    
    var dashLayer : CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if fullDashed == true {
            drawDashedBorder()
        }
        else {drawDashes()}
    }

    private func drawDashes() {
        
        let path = UIBezierPath.init()
        path.move(to: bounds.origin)
        path.addLine(to: CGPoint.init(x: bounds.origin.x + bounds.size.width, y: bounds.origin.y + bounds.size.height))
        path.stroke()
        
        dashLayer = CAShapeLayer.init()
        layer.addSublayer(dashLayer)
        
        dashLayer.strokeStart = 0.0
        dashLayer.strokeColor = dashColor.cgColor
        dashLayer.lineWidth = bounds.size.width
        dashLayer.lineJoin = kCALineJoinMiter
        dashLayer.lineDashPattern = [5, 2]
        dashLayer.lineDashPhase = 2.0
        dashLayer.path = path.cgPath
        
    }
    
    func drawDashedBorder() {
        if let _ = dashLayer {
            dashLayer.removeFromSuperlayer()
        }
        let color = UIColor.init(redInt: 39, greenInt: 156, blueInt: 229).cgColor
        
        dashLayer = CAShapeLayer.init()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        dashLayer.bounds = shapeRect
        dashLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        dashLayer.fillColor = UIColor.clear.cgColor
        dashLayer.strokeColor = color
        dashLayer.lineWidth = 1
        dashLayer.lineJoin = kCALineJoinRound
        dashLayer.lineDashPattern = [4,2]
        dashLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        layer.addSublayer(dashLayer)
    }
}
