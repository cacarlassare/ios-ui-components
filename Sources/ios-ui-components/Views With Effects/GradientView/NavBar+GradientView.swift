//
//  File.swift
//  
//
//  Created by Cristian Carlassare on 30/09/2021.
//

import UIKit


public extension UIViewController {
    
    func setNavBarGradientBackground(leftColor: UIColor, rightColor: UIColor, direction: GradientDirection) {
        let gradient = GradientView()
        
        var bounds = self.navigationController?.navigationBar.bounds ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        bounds.size.height += UIApplication.shared.statusBarFrame.size.height
        gradient.frame = bounds
        
        gradient.leftColor = leftColor
        gradient.rightColor = rightColor
        
        gradient.setDirection(direction)
        
        let gradientImage = gradient.asImage()
        
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
    }
}
