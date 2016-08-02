//
//  ColorSelectorViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/26.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit

protocol ColorSelectedViewDelegate{
    func setColor(color:UIColor)
}

class ColorSelectorViewController: UIViewController {
    
    var delegate: ColorSelectedViewDelegate?
    
    var colorKey:String?
    
    @IBOutlet weak var hue: GradientSlider!
    @IBOutlet weak var sat: GradientSlider!
    @IBOutlet weak var val: GradientSlider!
    
    @IBAction func hue(_ sender: AnyObject) {
        sat.setGradientForSaturationWithHue(hue: hue.value, brightness: val.value)
        val.setGradientForBrightnessWithHue(hue: hue.value, saturation: sat.value)
        update(value: hue)
    }
    @IBAction func sat(_ sender: AnyObject) {
        val.setGradientForBrightnessWithHue(hue: hue.value, saturation: sat.value)
        hue.setGradientForHueWithSaturation(saturation: sat.value, brightness: val.value)
        update(value: sat)
    }
    
    @IBAction func val(_ sender: AnyObject) {
        sat.setGradientForSaturationWithHue(hue: hue.value, brightness: val.value)
        hue.setGradientForHueWithSaturation(saturation: sat.value, brightness: val.value)
        update(value: val)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for i in [hue, sat, val]{
            i?.minimumValue = 0
            i?.maximumValue = 1
            i?.thickness = 8
        }
        
        UIColor.blue()
        
        hue.minColor = UIColor.blue()
        hue.hasRainbow = true
        
        let color = UserDefaults.standard.color(forKey: colorKey!)! as UIColor
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
        UserDefaults.standard.setColor(color: UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0), forKey: colorKey!)
        self.delegate?.setColor(color: UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0))
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize.width = UIScreen.main().bounds.width * 1.0
        self.preferredContentSize.height = UIScreen.main().bounds.height * 0.2
        
    }
    
    
    func update(value:GradientSlider){
        let currentColor = UIColor(hue: hue.value, saturation: sat.value, brightness: val.value, alpha: 1.0)
        for i in [hue, sat, val]{
            i?.thumbColor = currentColor
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
        
        self.delegate?.setColor(color: currentColor)


    }
    
}
