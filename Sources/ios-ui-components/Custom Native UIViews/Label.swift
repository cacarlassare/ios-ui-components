
import UIKit


open class Label: UILabel {

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.localizeText()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.localizeText()
    }
    
    
    func localizeText() {
        if let text = text {
            self.text = text.localized
        }
    }
}


// MARK: - Underlined Label

open class UnderlinedLabel: Label {
    
    open override var text: String! {
        didSet {
            let textRange = NSMakeRange(0, text.localized.count)
            let attributedText = NSMutableAttributedString(string: text.localized)
            
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value:NSUnderlineStyle.single.rawValue, range: textRange)
            
            self.attributedText = attributedText
        }
    }
}
