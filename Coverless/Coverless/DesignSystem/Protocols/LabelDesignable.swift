//
//  LabelDesignable.swift
//  Coverless
//
//  Created by Gabriel Ferreira de Carvalho on 15/09/21.
//

import UIKit

protocol LabelDesignable {
    func stylize(with textStyle: TextStyle)
    func setupAcessibility()
}

extension UILabel: LabelDesignable {
    
    func stylize(with textStyle: TextStyle) {
        self.font = textStyle.font
        self.textColor = textStyle.color
        self.textAlignment = textStyle.alignment
        
        if let textStyle = textStyle as? CustomLabelDesignable {
            textStyle.custom(self)
        }
        
        setupAcessibility()
    }
    
    func setupAcessibility() {
        self.adjustsFontForContentSizeCategory = true
    }
}

extension UITextView: LabelDesignable {
    func stylize(with textStyle: TextStyle) {
        font = textStyle.font
        textColor = textStyle.color
        textAlignment = textStyle.alignment
        backgroundColor = .clear
    }
    
    func setupAcessibility() {
        adjustsFontForContentSizeCategory = true
    }
    
    
}
