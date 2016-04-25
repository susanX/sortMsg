//
//  Colors.swift
//  graduatedbg
//
//  Created by s gooding on 15/04/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//  adpted from https://www.youtube.com/watch?v=pabNgxzEaRk
//  How To Add A Gradient Background In Swift
//  Dave Green accessed 15/04/16
import UIKit

extension CAGradientLayer {
    func turquoiseColor() -> CAGradientLayer {
        let topColor = UIColor(
            red:   126/255.0,
            green: 183/255.0,
            blue:  253/255.0,
            alpha: 1.0).CGColor
        
        let bottomColor = UIColor(
            red:   202/255.0,
            green: 226/255.0,
            blue:  255/255.0,
            alpha: 1.0).CGColor
        
        let gradientColors:   [CGColor] = [topColor, bottomColor]
        let gradientLocation: [Float] =   [0.0,1.0]
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors =    gradientColors
        gradientLayer.locations = gradientLocation
        
        return gradientLayer
        
    }






}
