
import UIKit


@objc public protocol TextFieldDelegate {
    @objc optional func textFieldDidChangeText(_ textField: UITextField)
}


open class TextField: UITextField {

    fileprivate var originalTextColor: UIColor!
    open var isReadOnly: Bool = false
    
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        self.setup()
    }
    
    fileprivate func setup() {
        self.localizePlaceholder()
        self.setCustomActions()
        self.originalTextColor = self.textColor
    }
    
    
    fileprivate func localizePlaceholder() {
        if let placeholder = placeholder {
            self.placeholder = placeholder.localized
        }
    }

    
    // MARK: Custom actions
    
    fileprivate func setCustomActions() {
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidChangeText), for: .editingChanged)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    
    // Delegate
    @objc open func textFieldDidChangeText() {
        if self.delegate is TextFieldDelegate {
            (self.delegate as! TextFieldDelegate).textFieldDidChangeText?(self)
        }
    }
    
    @objc open func editingDidBegin() { }
    
    @objc open func editingDidEnd() { }
        
    
    // MARK: - Enable And Disable Textfield
    
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
        self.textColor = self.originalTextColor
        self.isUserInteractionEnabled = true
    }
    
    open func disable() {
        super.isEnabled = false
        self.textColor = UIColor.lightGray
        self.isUserInteractionEnabled = false
    }
    
    
    // MARK: - Prevent Cutting Or pasting
    
    override open func target(forAction action: Selector, withSender sender: Any?) -> Any? {
        if self.isReadOnly {
            if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) {
                return nil
            }
        }
    
        return super.target(forAction: action, withSender: sender)
    }

    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.isReadOnly {
            if action == #selector(paste(_:)) ||
                action == #selector(cut(_:)) ||
                action == #selector(copy(_:)) ||
                action == #selector(select(_:)) ||
                action == #selector(selectAll(_:)) ||
                action == #selector(delete(_:)) ||
                action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
                action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
                action == #selector(toggleBoldface(_:)) ||
                action == #selector(toggleItalics(_:)) ||
                action == #selector(toggleUnderline(_:)) {
                return false
            }
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
