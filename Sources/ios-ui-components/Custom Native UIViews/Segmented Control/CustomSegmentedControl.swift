//
//  CustomSegmentedControl.swift
//  
//
//  Created by Cristian Carlassare.
//

import UIKit


// MARK: DELEGATE PROTOCOL

public protocol CustomSegmentedControlDelegate {
	func didSelectOption(_ option: Int)
}


// MARK: CLASS

open class CustomSegmentedControl: UIScrollView {
	
	// MARK: Constants
	
	struct UIConstants {
		static let indicatorHeight: CGFloat = 2
		static let buttonSpacing: CGFloat = 30
		static let scrollViewTrailingPadding: CGFloat = 40
		static let fontSize: CGFloat = 16
	}
	
	
	private var buttonTitles: [String]!
	private var buttons: [UIButton]!
	private var indicatorView: UIView!
	
	open var controlDelegate: CustomSegmentedControlDelegate?
	open var textColor: UIColor = .darkGray
	open var indicatorViewColor: UIColor = .systemBlue
	open var selectedTextColor: UIColor = .black
	
	
	// MARK: Initializers
	
	convenience public init(frame: CGRect, buttonTitles: [String]) {
		self.init(frame: frame)
		self.buttonTitles = buttonTitles
	}
	
	override public init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required public init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: Overrides
	
	open override func draw(_ rect: CGRect) {
		super.draw(rect)
        self.layoutView()
	}
	
	
	// MARK: Public methods
	
	func setButtonTitles(titles: [String]) {
        self.buttonTitles = titles
        self.layoutView()
	}
	
	func layoutView() {
        self.createButtons()
		
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.configStackView()
        self.configIndicatorView()
		
        self.selectButton(button: buttons.first)
	}
	
	
	// MARK: Private methods
	
	private func configStackView() {
		let stack = UIStackView(arrangedSubviews: buttons)
		stack.axis = .horizontal
		stack.alignment = .leading
		stack.distribution = .equalSpacing
		stack.spacing = 30

        self.addSubview(stack)
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: self.topAnchor),
			stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			stack.heightAnchor.constraint(equalTo: self.heightAnchor)
		])
		
        self.layoutIfNeeded()
        self.contentSize = CGSize(width: stack.frame.width + UIConstants.scrollViewTrailingPadding,
							 height: stack.frame.height)
	}
	
	private func configIndicatorView() {
        self.indicatorView = UIView()
        self.indicatorView.backgroundColor = indicatorViewColor
		
        self.addSubview(indicatorView)
	}
	
	private func createButtons() {
        self.buttons = [UIButton]()
        self.buttons.removeAll()
        self.subviews.forEach { $0.removeFromSuperview() }
		
        for buttonTitle in self.buttonTitles {
			let button = UIButton(type: .system)
			button.titleLabel?.font = .systemFont(ofSize: UIConstants.fontSize, weight: .regular)
			button.setTitle(buttonTitle.localized, for: .normal)
			button.setTitleColor(textColor, for: .normal)
			button.addTarget(self,
							 action: #selector(CustomSegmentedControl.buttonAction(sender:)),
							 for: .touchUpInside)
			
            self.buttons.append(button)
		}
	}
	
	private func selectButton(button: UIButton?) {
		guard let button = button else { return }
		
		UIView.animate(withDuration: 0.3) {
			button.titleLabel?.font = .systemFont(ofSize: UIConstants.fontSize, weight: .semibold)
			button.setTitleColor(self.selectedTextColor, for: .normal)
			
			self.layoutIfNeeded()
			
			self.indicatorView.frame = CGRect(x: button.frame.origin.x, y: self.frame.height - UIConstants.indicatorHeight, width: button.frame.width + 1, height: UIConstants.indicatorHeight)
		}
	}
	
	
	// MARK: Actions
	
	@objc func buttonAction(sender: UIButton) {
        
        for (index, button) in self.buttons.enumerated() {
			button.titleLabel?.font = .systemFont(ofSize: UIConstants.fontSize, weight: .regular)
            button.setTitleColor(self.textColor, for: .normal)
			
			if button == sender {
                self.selectButton(button: button)
                self.controlDelegate?.didSelectOption(index)
				
				let rect = CGRect(origin: CGPoint(x: button.frame.origin.x + UIConstants.scrollViewTrailingPadding, y: button.frame.origin.y), size: button.frame.size)
                self.scrollRectToVisible(index == 0 ? button.frame : rect, animated: true)
			}
		}
	}
}
