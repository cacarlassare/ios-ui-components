//
//  EmptyPlaceholderView.swift
//  
//
//  Created by Cristian Carlassare.
//

import UIKit


public protocol Emptiable {
	func addEmptyPlaceHolder(msg: String?)
}


open class EmptyPlaceholderView: UIView {
	
	open var message: String?
	open var textColor: UIColor?
	
    
	override open func draw(_ rect: CGRect) {
		super.draw(rect)
		
		// Label Add
		let placeHolderLabel = UILabel()
        self.addSubview(placeHolderLabel)
		
		// Label Size & Constraints
		placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			placeHolderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height / CGFloat(4)),
			placeHolderLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])
		
		// Label UI Tweaks
        placeHolderLabel.attributedText = NSAttributedString.init(string: message?.localized ?? "COMMON_NO_INFO_AVAILABLE".localized, attributes: [NSAttributedString.Key.foregroundColor : (textColor ?? .darkGray), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)])
	}
}
