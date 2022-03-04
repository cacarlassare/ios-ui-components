//
//  SkeletonView.swift
//  
//
//  Created by Cristian Carlassare.
//

import UIKit


public protocol SkeletonizableView: UIView {
    func showSkeletons()
    func dismissSkeletons()
}


// MARK: SkeletonView

open class SkeletonView: UIView {
    
    public enum SkeletonConstants {
        public static var cornerRadius: CGFloat = 3.0
        public static var colorA: CGColor = UIColor(red: 240.0 / 255.0, green: 239.0 / 255.0, blue: 239.0 / 255.0, alpha: 1.0).cgColor
        public static var colorB: CGColor = UIColor(red: 250.0 / 255.0, green: 250.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0).cgColor
    }
    
    public var originalCornerRadius: CGFloat = 0.0
    
    func addGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.name = "ShimmerLayer"
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayer.colors = [SkeletonConstants.colorA, SkeletonConstants.colorB, SkeletonConstants.colorA]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    func addAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 1.5
        return animation
    }
    
    public func startAnimation(cornerRadius: CGFloat? = nil) {
        let cornerRadius = cornerRadius ?? SkeletonConstants.cornerRadius
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let gradientLayer = self.addGradientLayer()
            gradientLayer.cornerRadius = cornerRadius
            
            self.originalCornerRadius = self.layer.cornerRadius
            self.layer.cornerRadius = cornerRadius + 1
            
            let animation = self.addAnimation()
            
            gradientLayer.add(animation, forKey: animation.keyPath)
        }
    }
    
    public func dismissAnimation(with duration: Double = 0.5) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: duration, animations: {
                self.layer.sublayers?
                    .filter { $0.name == "ShimmerLayer" }
                    .forEach { $0.opacity = 0.0 }
            }, completion: { _ in
                self.layer.sublayers?
                    .filter { $0.name == "ShimmerLayer" }
                    .forEach { $0.removeFromSuperlayer() }
                self.layer.cornerRadius = self.originalCornerRadius
            })
        }
    }
}


// MARK: UIView extension

public extension UIView {
    
    var skeletonViews: [SkeletonView] {
        subviews.compactMap { $0 as? SkeletonView }
    }
    
    func dismissSkeletonsView() {
        for case let skeleton as SkeletonView in self.subviews {
            skeleton.dismissAnimation()
            skeleton.removeFromSuperview()
        }
    }
    
    func createSkeleton(for view: UIView? = nil, cornerRadius: CGFloat = 0.0) {
        let referenceView = view ?? self
        
        let skView = SkeletonView(frame: referenceView.frame)
        self.addSubViewPinningEdges(skView)
        skView.startAnimation(cornerRadius: cornerRadius)
    }
}


// MARK: UILabel extension

public extension UILabel {
    
    enum Constants {
        static var cornerRadius: CGFloat = 3.0
        static var heightSpacingLines: CGFloat = 6
        static var lastLineWithPercentage: CGFloat = 0.46
    }
    
    func createLineSkeleton(cornerRadius: CGFloat? = nil, maxWidth: CGFloat? = nil, skeletonLineHeight: CGFloat? = nil) {
        let cornerRadius = cornerRadius ?? Constants.cornerRadius
        let initialWidth = maxWidth ?? bounds.width
        let skeletonLineHeight = skeletonLineHeight ?? font.lineHeight
        let lineBlockHeight: CGFloat = skeletonLineHeight + Constants.heightSpacingLines
        
        let numberOfLines = calculateMaxLines(lineBlockHeight: lineBlockHeight)
        let remainingSpace = calculateRemainingSpace(forLines: numberOfLines, lineBlockHeight: lineBlockHeight)
        
        for iteration in 0..<numberOfLines {
            let withPercentage: CGFloat = iteration != 0 && iteration == numberOfLines - 1 ? Constants.lastLineWithPercentage : 1
            
            let skWidth = initialWidth * withPercentage
            let currentY = remainingSpace / 2 + lineBlockHeight * CGFloat(iteration)
            
            let skView = SkeletonView()
            
            skView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(skView)
            
            if numberOfLines > 1 {
                skView.topAnchor.constraint(equalTo: topAnchor, constant: currentY).isActive = true
            } else {
                skView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
            
            skView.widthAnchor.constraint(equalToConstant: skWidth).isActive = true
            skView.heightAnchor.constraint(equalToConstant: skeletonLineHeight).isActive = true
            
            switch textAlignment {
            case .center:
                skView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            case .right, .natural:
                trailingAnchor.constraint(equalTo: skView.trailingAnchor).isActive = true
            default:
                skView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            }
        }
        text = ""
        skeletonViews.forEach { $0.startAnimation(cornerRadius: cornerRadius) }
    }
    
    private func calculateRemainingSpace(forLines numberOfLines: Int, lineBlockHeight: CGFloat) -> CGFloat {
        return bounds.height - lineBlockHeight * CGFloat(numberOfLines) + Constants.heightSpacingLines
    }
    
    private func calculateMaxLines(lineBlockHeight: CGFloat) -> Int {
        self.layoutIfNeeded()
        
        var numberOfLines = self.numberOfLines
        
        if numberOfLines == 0 {
            let estimatedNumberLines = bounds.height / lineBlockHeight
            numberOfLines = Int(floor(estimatedNumberLines))
        }
        
        return numberOfLines
    }
}
