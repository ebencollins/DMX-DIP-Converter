//
//  ColorSelectorViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/26.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit

protocol ColorSelectedViewDelegate{
    func setColor(main:UIColor, text:UIColor)
}

class ColorSelectorViewController: UIViewController {
    
    var delegate: ColorSelectedViewDelegate?
    
    var colorKeys:(main: String, text: String)?
    
    let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!

    
    func hueVC(_ sender: AnyObject) {
        sat.setGradientForSaturationWithHue(hue: hue.value, brightness: val.value)
        val.setGradientForBrightnessWithHue(hue: hue.value, saturation: sat.value)
        update(value: hue)
    }
    func satVC(_ sender: AnyObject) {
        val.setGradientForBrightnessWithHue(hue: hue.value, saturation: sat.value)
        hue.setGradientForHueWithSaturation(saturation: sat.value, brightness: val.value)
        update(value: sat)
    }
    
    func valVC(_ sender: AnyObject) {
        sat.setGradientForSaturationWithHue(hue: hue.value, brightness: val.value)
        hue.setGradientForHueWithSaturation(saturation: sat.value, brightness: val.value)
        update(value: val)
    }
    
    var hue:GradientSlider = GradientSlider()
    var sat:GradientSlider = GradientSlider()
    var val:GradientSlider = GradientSlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hue.addTarget(nil, action: #selector(hueVC(_:)), for: .valueChanged)
        sat.addTarget(nil, action: #selector(hueVC(_:)), for: .valueChanged)
        val.addTarget(nil, action: #selector(hueVC(_:)), for: .valueChanged)
        self.view.addSubview(hue)
        self.view.addSubview(sat)
        self.view.addSubview(val)
        
        
        for i in [hue, sat, val]{
            i.minimumValue = 0
            i.maximumValue = 1
            i.thickness = 8
        }
        
        hue.minColor = UIColor.blue
        hue.hasRainbow = true
        
        let color = defaults.color(forKey: colorKeys!.main)! as UIColor
        var h:CGFloat = 0
        var s:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        hue.setValue(value: h);
        sat.setValue(value: s);
        val.setValue(value: b)
        
        
        update(value: hue)
        update(value: sat)
        update(value: val)
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.setColor(color: UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0), forKey: colorKeys!.main)
        self.delegate?.setColor(main: UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0), text: UIColor.white)
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize.width = UIScreen.main.bounds.width * 1.0
        self.preferredContentSize.height = UIScreen.main.bounds.height * 0.2
        
        
        let sliderHeight = self.view.bounds.height * 0.1
        let sliderWidth = self.view.bounds.width
        hue.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        sat.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 3*self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        val.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 5*self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
    }
    
    
    func update(value:GradientSlider){
        let currentColor = UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0)
        for i in [hue, sat, val]{
            i.thumbColor = currentColor
        }
        if value != hue{
            hue.setGradientForHueWithSaturation(saturation: sat.value, brightness: val.value)
        }
        if value != sat{
            sat.setGradientForSaturationWithHue(hue: hue.value, brightness: val.value)
        }
        if value != val{
            val.setGradientForBrightnessWithHue(hue: hue.value, saturation: sat.value)
        }
        
        self.delegate?.setColor(main: currentColor, text: UIColor.orange)


    }
    
}
