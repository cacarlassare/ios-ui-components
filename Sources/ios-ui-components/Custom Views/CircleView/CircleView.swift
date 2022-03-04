//
//  CircleView.swift
//  iOSApp
//
//  Created by Cristian Carlassare.
//

import UIKit


open class CircleView: UIView {
    
    public var fillColor: UIColor = .white
    public var borderColor: UIColor = .lightGray
    public var borderWidth: CGFloat = 4.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    open override func draw(_ rect: CGRect) {
        self.fillColor.setFill()
        self.borderColor.setStroke()

        let circlePath = UIBezierPath(ovalIn: CGRect(x: self.borderWidth, y: self.borderWidth, width: rect.width - self.borderWidth * 2, height: rect.height - self.borderWidth * 2))
        circlePath.lineWidth = self.borderWidth

        circlePath.stroke()
        circlePath.fill()
    }
}
