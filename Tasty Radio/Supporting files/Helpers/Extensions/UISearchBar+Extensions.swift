//
//  UISearchBar+Extensions.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 11/28/20.
//  Copyright © 2020 DEVLAB, LLC. All rights reserved.
//

import UIKit

extension UISearchBar {

    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        }
        else {
            for view : UIView in (self.subviews[0]).subviews {
                if let textField = view as? UITextField {
                    return textField
                }
            }
        }
        return nil
    }

    func setTextFieldColor(color: UIColor) {
        if let textField = getViewElement(type: UITextField.self) {
            textField.backgroundColor    = color
            textField.borderStyle        = .none
            textField.clipsToBounds      = true
            textField.layer.cornerRadius = 4.0
        }
    }

    private func getSearchBarTextField() -> UITextField? {
        return getViewElement(type: UITextField.self)
    }

    private func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard
            let element = (svs.filter { $0 is T }).first as? T else {
                return nil
        }
        return element
    }

}
