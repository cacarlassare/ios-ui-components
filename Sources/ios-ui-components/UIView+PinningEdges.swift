//
//  UIView+PinningEdges.swift
//  
//
//  Created by Cristian Carlassare.
//


import UIKit

public enum AnchorTypes {
    case right
    case left
    case top
    case bottom
}


// MARK: - Pin Edges of the view to another view (commonly the superview)

extension UIView {
    
    func addSubViewPinningEdges(_ view: UIView, anchors: [AnchorTypes]? = nil) {
        self.addSubview(view)
        
        if let anchors = anchors {
            view.pinEdges(to: self, anchors: anchors)
        } else {
            view.pinEdges(to: self)
        }
    }

    func pinEdges(to other: UIView, anchors: [AnchorTypes]) {
        
        if anchors.isEmpty {
            self.pinEdges(to: other)
            return
        }
        
        
        if anchors.contains(.left) {
            self.frame.origin.x = 0
            leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        }
        
        if anchors.contains(.right) {
            if anchors.contains(.left) {
                self.frame.size.width = other.frame.size.width
            } else {
                self.frame.origin.x = other.frame.size.width - self.frame.size.width
            }
            
            trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        }
        
        if anchors.contains(.top) {
            self.frame.origin.y = 0
            topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        }
        
        if anchors.contains(.bottom) {
            if anchors.contains(.top) {
                self.frame.size.height = other.frame.size.height
            } else {
                self.frame.origin.y = other.frame.size.height - self.frame.size.height
            }
            
            bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
        }
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
    }
    
    func pinEdges(to other: UIView) {
        self.frame = CGRect(x: 0, y: 0, width: other.frame.width, height: other.frame.height)
        self.leadingAnchor.constraint(equalTo: other.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: other.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: other.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: other.bottomAnchor).isActive = true
        
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
    }
}
