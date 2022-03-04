//
//  CustomNavBarView.swift
//  
//
//  Created by Natu Brasesco on 10/09/2021.
//

import UIKit


// MARK: Custom NavBar View

class CustomNavBarView: UIView {
    
    open func setTitleLabel(_ label: UILabel, to position: NavItemPosition) {
        
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: UIApplication.shared.statusBarFrame.height/2).isActive = true
        switch position {
            case .left:
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
            case .right:
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
            case .center:
                label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
    }
    
    open func setNavItems(_ navItems: [UIButton], to position: NavItemPosition) {
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: UIApplication.shared.statusBarFrame.height/2).isActive = true
        switch position {
            case .left:
                stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
            case .right:
                stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
            case .center:
                stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        }
        
        for item in navItems {
            stackView.addArrangedSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                item.widthAnchor.constraint(equalToConstant: 33),
                item.heightAnchor.constraint(equalToConstant: 33)
            ])
        }
    }
}
