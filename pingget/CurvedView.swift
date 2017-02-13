//
//  CurvedView.swift
//  pingget
//
//  Created by Victor on 22.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class CurvedView: UIView {

    override func draw(_ rect: CGRect) {
        let width = rect.width - 10
        let height = rect.height - 5
        let x = rect.origin.x + 5
        let y = rect.origin.y
        
        let context = UIGraphicsGetCurrentContext()
        let shadow = UIColor.init(white: 0, alpha: 0.5)
        let shadowOffset = CGSize.init(width: 0, height: 3.0)
        
        let curveStart = rect.origin
        let controlPoint1 = CGPoint.init(x: x + width / 6, y: y)
        let controlPoint2 = CGPoint.init(x: x + width / 6 * 5, y: y)
        let arcCenterPoint = CGPoint.init(x: x + width / 2, y: height / 3)
        let curveIntreimPoint1 = CGPoint.init(x: x + width / 6, y: height / 3)
        let curveEnd = CGPoint.init(x: x + width, y: y)
        let curve = UIBezierPath.init()
        curve.move(to: curveStart)
        curve.addQuadCurve(to: curveIntreimPoint1, controlPoint: controlPoint1)
        curve.addArc(withCenter: arcCenterPoint, radius: width / 3, startAngle: 180.0 / 180.0 * CGFloat(M_PI), endAngle: 0.0, clockwise: false)
        curve.addQuadCurve(to: curveEnd, controlPoint: controlPoint2)
//        curve.addLine(to: curveStart)
//        curve.close()
        context?.saveGState()
        context?.setShadow(offset: shadowOffset, blur: 3.0, color: shadow.cgColor)
        
        UIColor.clear.setStroke()
        UIColor.white.setFill()
        curve.fill()
        curve.stroke()
        context?.restoreGState()
    }
}
