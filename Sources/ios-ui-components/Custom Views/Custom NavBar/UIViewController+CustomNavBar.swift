//
//  UIViewController+CustomNavBar.swift
//  
//
//  Created by Cristian Carlassare.
//

import UIKit


// MARK: Custom NavBar set-up

public enum NavItemPosition {
    case left
    case right
    case center
}


@available(iOS 11.0, *)
public extension UIViewController {
    
    private struct UIConstants {
        static let titleLabelTag: Int = 111
        static let weatherBannerHeight: CGFloat = 80
        static let weatherBannerNavBarOverlay: CGFloat = 23
        static let weatherBannerLeadingConstant: CGFloat = 20
    }
    
    // Hides native NavBar to set up custom one.
    // Creates custom view only if it doesn't already exist.
    func setUpCustomNavBar(title: String? = nil, titlePosition: NavItemPosition = .left,  backgroundColor: UIColor? = nil, barHeight: CGFloat, cornerRadius: CGFloat? = nil, navItems: [UIButton]? = nil, itemsPosition: NavItemPosition = .right) {
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        
        if title != self.title {
            self.title = title
            self.updateTitleLabel()
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        guard let _ = self.view.subviews.first(where: { $0 is CustomNavBarView}) else {
            self.setCustomNavBarBackgroundView(backgroundColor: backgroundColor, barHeight: barHeight, cornerRadius: cornerRadius)
            
            if let navTitle = self.title { self.setCustomNavBarTitle(navTitle, titlePosition: titlePosition) }
            if let navItems = navItems { self.setCustomNavItems(navItems, itemsPosition: itemsPosition) }
            
            return
        }
        
        self.expandCustomNavBar(barHeight: barHeight, cornerRadius: cornerRadius ?? 40)
    }
    
    // Creates (slightly) overlayed banner on top of NavBar, displaying weather info.
    // If created, Safe Area top insets are updated and animated.
    func setUpWeatherBanner(with weatherInfo: WeatherInfo, backgroundColor: UIColor = .white, cornerRadius: CGFloat = 20) {
        guard let customNavBarView = self.view.subviews.first(where: { $0 is CustomNavBarView}) else { return }
        
        let bannerView = WeatherBannerView()
        bannerView.layer.cornerRadius = cornerRadius
        bannerView.backgroundColor = backgroundColor
        bannerView.alpha = 0
        
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bannerView.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor,
                                            constant: -UIConstants.weatherBannerNavBarOverlay),
            bannerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
                                                constant: UIConstants.weatherBannerLeadingConstant),
            bannerView.heightAnchor.constraint(equalToConstant: UIConstants.weatherBannerHeight)
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.additionalSafeAreaInsets.top += (UIConstants.weatherBannerHeight - UIConstants.weatherBannerNavBarOverlay)
            bannerView.alpha = 1
        })
        
        bannerView.setWeatherInfo(weatherInfo: weatherInfo)
    }
    
    // Adds CustomNavBarView in place of native navBar
    private func setCustomNavBarBackgroundView(backgroundColor: UIColor? = nil, barHeight: CGFloat, cornerRadius: CGFloat? = nil) {
        let customNavBarView = CustomNavBarView()
        customNavBarView.backgroundColor = backgroundColor ?? .white
        self.view.addSubview(customNavBarView)
        self.additionalSafeAreaInsets.top = barHeight - UIApplication.shared.statusBarFrame.height
        
        // Optionally adds rounded BOTTOM corners
        if let radius = cornerRadius {
            customNavBarView.clipsToBounds = true
            customNavBarView.layer.cornerRadius = radius
            customNavBarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        
        // Constraints
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: self.view.topAnchor),
            customNavBarView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            customNavBarView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            customNavBarView.heightAnchor.constraint(equalToConstant: barHeight)
        ])
    }
    
    // Creates title label and adds it to CustomNavBarView
    private func setCustomNavBarTitle(_ title: String? = nil, titlePosition: NavItemPosition, color: UIColor = .white, font: UIFont = UIFont.systemFont(ofSize: 20, weight: .semibold)) {
        
        guard let view = self.view.subviews.first(where: { $0 is CustomNavBarView}), let customNavBarView = view as? CustomNavBarView
        else { return }
        
        let titleLabel = UILabel()
        titleLabel.tag = UIConstants.titleLabelTag
        titleLabel.font = font
        titleLabel.textColor = color
        titleLabel.text = title
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 1
        
        customNavBarView.setTitleLabel(titleLabel, to: titlePosition)
    }
    
    // Updates titleLabel's text if navBar exists
    private func updateTitleLabel() {
        guard let view = self.view.subviews.first(where: { $0 is CustomNavBarView}),
              let customNavBarView = view as? CustomNavBarView,
              let titleLabel = customNavBarView.viewWithTag(UIConstants.titleLabelTag) as? UILabel
        else { return }
        
        if let navTitle = self.title { titleLabel.text = navTitle }
    }
    
    // Adds NavItems (buttons) to CustomNavBarView
    private func setCustomNavItems(_ navItems: [UIButton], itemsPosition: NavItemPosition) {
        
        guard let view = self.view.subviews.first(where: { $0 is CustomNavBarView}),
              let customNavBarView = view as? CustomNavBarView
        else { return }
        
        customNavBarView.setNavItems(navItems, to: itemsPosition)
    }
    
    // Expands CustomNavBar (on viewWillAppear)
    func expandCustomNavBar(barHeight: CGFloat, cornerRadius: CGFloat) {
        guard let customNavBarView = self.view.subviews.first(where: { $0 is CustomNavBarView}) else { return }
        
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        
        if let heightAnchor = customNavBarView.constraints.first (where: { $0.firstAnchor == customNavBarView.heightAnchor }) { customNavBarView.removeConstraint(heightAnchor) }
        customNavBarView.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        
        var safeAreaTop = barHeight - UIApplication.shared.statusBarFrame.height
        if let _ = self.view.subviews.first(where: { $0 is WeatherBannerView}) {
            // If a weather banner also exists, safeAreaTopInset should include it's height
            // (minus its overlay on the NavBar)
            safeAreaTop += (UIConstants.weatherBannerHeight - UIConstants.weatherBannerNavBarOverlay)
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            customNavBarView.layer.cornerRadius = cornerRadius
            self.additionalSafeAreaInsets.top = safeAreaTop
            
            for view in customNavBarView.subviews {
                view.alpha = view.alpha == 0 ? 1 : 0
            }
            
            self.view.layoutIfNeeded()
        })
    }
    
    // Shrinks CustomNavBar (on viewWillDisappear)
    func shrinkCustomNavBar() {
        guard let customNavBarView = self.view.subviews.first(where: { $0 is CustomNavBarView}) else { return }
        
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        
        if let heightAnchor = customNavBarView.constraints.first (where: { $0.firstAnchor == customNavBarView.heightAnchor }) { customNavBarView.removeConstraint(heightAnchor) }
        customNavBarView.heightAnchor.constraint(equalToConstant: UIApplication.shared.statusBarFrame.height + 44).isActive = true
        
        UIView.animate(withDuration: 0.5, animations: {
            customNavBarView.layer.cornerRadius = 0
            self.additionalSafeAreaInsets.top = UIApplication.shared.statusBarFrame.height

            for view in customNavBarView.subviews {
                view.alpha = view.alpha == 0 ? 1 : 0
            }
            
            self.view.layoutIfNeeded()
        })
    }
}
