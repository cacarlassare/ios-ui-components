
import UIKit


open class Button: UIButton {

    open override func awakeFromNib() {
        super.awakeFromNib()
        
        for state in [UIControl.State.normal, UIControl.State.highlighted, UIControl.State.selected, UIControl.State.disabled] {
            
            if let title = title(for: state) {
                self.setTitle(title, for: state)
            }
        }
    }
    
    open override func setTitle(_ title: String?, for state: UIControl.State) {
        if let title = title {
            super.setTitle(title.localized, for: state)
        } else {
            super.setTitle(title, for: state)
        }
    }
    
    open func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
    
    
    // MARK: - Enable And Disable Button
    
    override open var isEnabled: Bool {
        didSet {
            if super.isEnabled {
                self.enable()
            } else {
                self.disable()
            }
        }
    }
    
    open func enable() {
        super.isEnabled = true
        self.isUserInteractionEnabled = true
    }
    
    open func disable() {
        super.isEnabled = false
        self.isUserInteractionEnabled = false
    }
}
