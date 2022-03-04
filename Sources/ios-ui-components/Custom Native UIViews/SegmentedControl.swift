//
//  DesignableUIViews.swift
//
//
//  Created by Cristian Carlassare.
//

import UIKit


open class SegmentedControl: UISegmentedControl {

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.localizeTitles()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.localizeTitles()
    }
    
    func localizeTitles() {
        for i in 0 ..< self.numberOfSegments {
            let title = self.titleForSegment(at: i)
            self.setTitle(title?.localized, forSegmentAt: i)
        }
    }
}
