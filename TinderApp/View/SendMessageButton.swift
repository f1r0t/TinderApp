//
//  SendMessageButton.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 8.01.2024.
//

import UIKit

class SendMessageButton: UIButton{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9921568627, green: 0.3568627451, blue: 0.3725490196, alpha: 1)
        let rightColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
}

