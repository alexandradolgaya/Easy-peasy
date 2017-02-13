//
//  BottomDashedView.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/16/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class BottomDashedView: UIView {
    var dashedLine = CAShapeLayer()
    
    override func awakeFromNib() {
        addDashedLine()
    }
    
    override func layoutSubviews() {
        setDahedLinePath()
    }
    
    private func setDahedLinePath() {
        let dashedLineHeight: CGFloat = 1
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 0, y: frame.height - dashedLineHeight))
        linePath.addLine(to: CGPoint(x: frame.width, y: frame.height - dashedLineHeight))
        dashedLine.path = linePath.cgPath
    }
    
    func addDashedLine() {
        setDahedLinePath()
        dashedLine.strokeColor = UIColor(redInt: 231, greenInt: 238, blueInt: 244).cgColor
        dashedLine.lineWidth = 1
        dashedLine.lineJoin = kCALineJoinRound
        dashedLine.lineDashPattern = [3, 2]
        layer.addSublayer(dashedLine)
    }
}
