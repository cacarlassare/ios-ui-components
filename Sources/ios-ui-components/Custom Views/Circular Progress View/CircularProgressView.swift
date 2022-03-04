//
//  CircularProgressView.swift
//  
//
//  Created by Cristian Carlassare.
//

import UIKit


open class CircularProgressView: UIView {
    
    
    // MARK: Public props
    
    open var previousValue: CGFloat?
    open var progressColor = UIColor.red {
        didSet { self.progressLayer.strokeColor = self.progressColor.cgColor }
    }
    
    
    // MARK: Private props
    
    fileprivate var progressLayer = CAShapeLayer()
    
    
    // MARK: Lifecycle overrides
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        self.createCircularPath()
    }
    
    
    // MARK: Public methods
    
    open func animateProgress(duration: TimeInterval = 0.3, progressValue: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = self.previousValue ?? 0.0
        animation.toValue = progressValue
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        
        self.progressLayer.strokeEnd = progressValue
        self.progressLayer.add(animation, forKey: "progressAnimation")
    }
    
    
    // MARK: Private methods
    
    fileprivate func createCircularPath() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = frame.width/2
        self.clipsToBounds = true
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: (frame.width * 0.9)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        
        self.progressLayer.path = circlePath.cgPath
        self.progressLayer.fillColor = UIColor.clear.cgColor
        self.progressLayer.strokeColor = self.progressColor.cgColor
        self.progressLayer.lineWidth = frame.width * 0.1
        self.progressLayer.strokeEnd = 0.0
        layer.addSublayer(self.progressLayer)
    }
}
