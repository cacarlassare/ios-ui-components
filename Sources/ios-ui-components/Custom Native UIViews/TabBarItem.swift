
import UIKit


open class TabBarItem: UITabBarItem {

    open override func awakeFromNib() {
        super.awakeFromNib()
        self.localizeItems()
    }
    
    
    func localizeItems() {
        if let text = self.title {
            self.title = text.localized
        }
    }
}
