//
//  Extensions.swift
//  theProject
//
//  Created by Chris Rodriguez on 1/2/19.
//  Copyright © 2019 Chris. All rights reserved.
//

import Foundation
import UIKit

extension UITextField
{
    func setBottomBorder()
    {
        self.borderStyle = UITextBorderStyle.none;
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.darkGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,   width:  self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
extension UIButton {
    func applyDesign() {
        //self.backgroundColor = UIColor.darkGray.withAlphaComponent(1)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.layer.cornerRadius = self.frame.height / 6 // Rounds corners completely.
        self.setTitleColor(UIColor.darkGray, for: .normal)
    }
    func roundButton() {
        self.layer.cornerRadius = self.frame.height / 2 // Rounds corners completely.
        self.clipsToBounds = true
    }
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.isEnabled = false
            self.alpha = 0.5
            self.setTitle("", for: .normal)
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = UIColor.black
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.isEnabled = true
            self.alpha = 1.0
            self.setTitle("Login", for: .normal)
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}
extension String{
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = anyImage
    }
}
