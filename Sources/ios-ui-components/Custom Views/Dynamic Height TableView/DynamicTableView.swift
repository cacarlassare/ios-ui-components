//
//  DynamicTableView.swift
//  
//
//  Created by Natu Brasesco on 19/05/2021.
//

import UIKit


open class DynamicTableView: UITableView {
	
	open var maxHeight = CGFloat.infinity

	override open var contentSize: CGSize {
		didSet {
			invalidateIntrinsicContentSize()
			setNeedsLayout()
		}
	}

	override open var intrinsicContentSize: CGSize {
        let height = min(self.contentSize.height, self.maxHeight)
        return CGSize(width: self.contentSize.width, height: height)
	}

	override open func reloadData() {
		super.reloadData()
		invalidateIntrinsicContentSize()
		layoutIfNeeded()
		
        let contentSizeIsSmaller = self.contentSize.height < self.maxHeight
		self.isScrollEnabled = !contentSizeIsSmaller
	}
}
