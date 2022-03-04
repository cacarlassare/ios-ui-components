//
//  String+Localizable.swift
//  
//
//  Created by Cristian Carlassare.
//

import Foundation


internal extension String {
    
    static var forcedLanguage: String?
    
    // MARK: - Localization
    
    var localized: String {
        if let forcedLanguage = String.forcedLanguage  {
            return self.localized(for: forcedLanguage)
        }
        
        return NSLocalizedString(self, comment: "")
    }
    
    fileprivate func localized(for language: String) -> String {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: "")
        
        return localizedString
    }

}
