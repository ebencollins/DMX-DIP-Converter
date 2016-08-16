//
//  DMX-DIP.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 2016-08-16.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit
import Foundation

struct DMXDIP{
    func dipsToNum(dips:[Bool]) -> Int{ //input an array containing the values of the dips to return the integer address
        var finalNumber = 0
        for i in 0..<dips.count{
            if dips[i]{ //if the dip is active, add it's cooresponding power to the final output
                finalNumber += Int(pow(2.0, Double(i)))
            }
        }
        return finalNumber
    }
    
    func numToDips(num:Int) -> [Bool]{ //input a number, return an array of dips
        var dips:[Bool] = []
        var i:Double = Double(num)
        
        for _ in 0..<9{
            dips.append(false)
        }
        
        while i > 0{
            dips[Int(floor(log2(i)))] = true
            i -= pow(2.0, Double(floor(log2(i))))
        }
        return dips;
    }

    
}

extension UserDefaults{
    
    
    //    func set(color:UIColor?, forKey:String){
    //        var colorData:NSData?
    //        if let color = color{
    //            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
    //        }
    //        set(colorData, forKey: forKey)
    //    }
    
    func color(forKey: String) -> UIColor? {
        var color: UIColor? = UIColor.clear()
        if let colorData = data(forKey: forKey) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        }
        set(colorData, forKey: key)
    }
    
    func checkDefaults(){
        let defaults = UserDefaults.standard
        if(defaults.value(forKey: "preventSleep") == nil){
            defaults.set(true, forKey: "preventSleep")
        }
        if(defaults.value(forKey: "invertDirection") == nil){
            defaults.set(false, forKey: "invertDirection")
        }
        if(defaults.value(forKey: "offsetAmount") == nil){
            defaults.set(16, forKey: "offsetAmount")
        }
        if(defaults.value(forKey: "switchLabels") == nil){
            defaults.set(0, forKey: "switchLabels")
        }
        
        if(defaults.value(forKey: "btColor") == nil){
            defaults.setColor(color: UIColor.lightText(), forKey: "btColor")
        }
        if(defaults.value(forKey: "swtColor") == nil){
            defaults.setColor(color: UIColor.black(), forKey: "swtColor")
        }
        if(defaults.value(forKey: "otColor") == nil){
            defaults.setColor(color: UIColor.lightText(), forKey: "otColor")
        }
        if(defaults.value(forKey: "bColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.26, alpha: 1.0), forKey: "bColor")
        }
        if(defaults.value(forKey: "swColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.60, alpha: 1.0), forKey: "swColor")
        }
        if(defaults.value(forKey: "oColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.26, alpha: 1.0), forKey: "oColor")
        }
        
    }
}
