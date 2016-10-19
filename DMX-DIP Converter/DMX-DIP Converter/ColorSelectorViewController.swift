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
    private let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
    
    var delegate: ColorSelectedViewDelegate?
    var colorKeys:(main: String, text: String)?

    private var colorSliders:[String: GradientSlider] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorSliders["hue"] = GradientSlider()
        colorSliders["sat"] = GradientSlider()
        colorSliders["val"] = GradientSlider()
        
        colorSliders["hue"]?.minColor = .blue
        colorSliders["hue"]?.hasRainbow = true
        
        for slider in colorSliders.values{
            slider.addTarget(nil, action: #selector(valueChanged(sender:)), for: .valueChanged)
            slider.minimumValue = 0
            slider.maximumValue = 1
            slider.thickness = 8
            self.view.addSubview(slider)
        }
        
        let color = defaults.color(forKey: colorKeys!.main)! as UIColor
        var currentColor:(hue: CGFloat, sat: CGFloat, val: CGFloat, alpha: CGFloat) = (0, 0, 0, 0)
        color.getHue(&currentColor.hue, saturation: &currentColor.sat, brightness: &currentColor.val, alpha: &currentColor.alpha)
        
        colorSliders["hue"]?.setValue(value: currentColor.hue);
        colorSliders["sat"]?.setValue(value: currentColor.sat);
        colorSliders["val"]?.setValue(value: currentColor.val)
        
        
        for slider in colorSliders.values{
            update(gradientSlider: slider)
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.setColor(color: UIColor(hue: (colorSliders["hue"]?.value)!, saturation: (colorSliders["sat"]?.value)!, brightness: (colorSliders["val"]?.value)!, alpha: 1.0), forKey: colorKeys!.main)
        self.delegate?.setColor(main: UIColor(hue: (colorSliders["hue"]?.value)!, saturation: (colorSliders["sat"]?.value)!, brightness: (colorSliders["val"]?.value)!, alpha: 1.0), text: UIColor.white)
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize.width = UIScreen.main.bounds.width * 1.0
        self.preferredContentSize.height = UIScreen.main.bounds.height * 0.2
        
        
        let sliderHeight = self.view.bounds.height * 0.1
        let sliderWidth = self.view.bounds.width
        colorSliders["hue"]?.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        colorSliders["sat"]?.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 3*self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
        colorSliders["val"]?.frame = CGRect(x: self.view.bounds.minX, y: self.view.bounds.minY + 5*self.view.bounds.height/6 - sliderHeight/2, width: sliderWidth, height: sliderHeight)
    }
    
    
    func update(gradientSlider:GradientSlider){
        let currentColor = UIColor(hue: (colorSliders["hue"]?.value)!, saturation: (colorSliders["sat"]?.value)!, brightness: (colorSliders["val"]?.value)!, alpha: 1.0)
        for slider in colorSliders.values{
            slider.thumbColor = currentColor
        }
        if gradientSlider != colorSliders["hue"]!{
            colorSliders["hue"]?.setGradientForHueWithSaturation(saturation: (colorSliders["sat"]?.value)!, brightness: (colorSliders["val"]?.value)!)
        }
        if gradientSlider != colorSliders["sat"]!{
            colorSliders["sat"]?.setGradientForSaturationWithHue(hue: (colorSliders["hue"]?.value)!, brightness: (colorSliders["val"]?.value)!)
        }
        if gradientSlider != colorSliders["val"]!{
            colorSliders["val"]?.setGradientForBrightnessWithHue(hue: (colorSliders["hue"]?.value)!, saturation: (colorSliders["sat"]?.value)!)
        }
        
        self.delegate?.setColor(main: UIColor(hue: (colorSliders["hue"]?.value)!, saturation: (colorSliders["sat"]?.value)!, brightness: (colorSliders["val"]?.value)!, alpha: 1.0), text: UIColor.orange)

    }
    
    func valueChanged(sender: GradientSlider){
        update(gradientSlider: sender)
    }
    
}
