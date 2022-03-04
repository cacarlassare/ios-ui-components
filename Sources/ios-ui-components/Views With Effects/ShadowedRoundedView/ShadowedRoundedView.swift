//
//  ShadowedRoundedView.swift
//  
//
//  Created by Rodrigo Cian Berrios on 08/06/2021.
//

import UIKit


open class ShadowedRoundedView: UIView {
    
    public var shadowView: UIView?
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.addRoundedAndShadow()
    }
    
    private func addRoundedAndShadow() {
        if self.shadowView == nil {
            self.shadowView = UIView()
            
            self.superview?.addSubview(shadowView!)
            self.superview?.sendSubviewToBack(shadowView!)
        }
        
        self.shadowView?.frame = self.frame
        self.shadowView?.layer.cornerRadius = self.layer.cornerRadius
        self.shadowView?.layer.borderColor = self.layer.borderColor
        self.shadowView?.layer.shadowColor = self.layer.shadowColor
        self.shadowView?.backgroundColor = self.backgroundColor
        self.shadowView?.alpha = 1.0
        self.shadowView?.layer.shadowOffset = self.layer.shadowOffset
        self.shadowView?.layer.shadowOpacity = self.layer.shadowOpacity
        self.shadowView?.layer.shadowRadius = self.layer.shadowRadius
    }
    
    public override func removeFromSuperview() {
        super.removeFromSuperview()
        self.shadowView?.removeFromSuperview()
    }
}
