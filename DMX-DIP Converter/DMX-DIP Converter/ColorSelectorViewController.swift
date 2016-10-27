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
    
    var mainColorSelector: ColorSelector?
    var textColorSelector: ColorSelector?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainColorSelector = ColorSelector(frame: CGRect(x: 0, y: 0, width: 0, height: 0), startColor: defaults.color(forKey: (colorKeys?.main)!)!)
        textColorSelector = ColorSelector(frame: CGRect(x: 0, y: 0, width: 0, height: 0), startColor: defaults.color(forKey: (colorKeys?.text)!)!)
        for cs in [mainColorSelector, textColorSelector]{
            cs?.addTarget(nil, action: #selector(colorSelectorValueChanged(sender:)), for: .valueChanged)
            self.view.addSubview(cs!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.setColor(color: mainColorSelector?.color, forKey: (colorKeys?.main)!)
        defaults.setColor(color: textColorSelector?.color, forKey: (colorKeys?.text)!)
        self.delegate?.setColor(main: (mainColorSelector?.color)!, text: (textColorSelector?.color)!)
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize.width = UIScreen.main.bounds.width * 1.0
        self.preferredContentSize.height = UIScreen.main.bounds.height * 0.3
        
        mainColorSelector?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2)
        textColorSelector?.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: self.view.frame.height/2)
        
        drawLineFromPoint(start: CGPoint(x: 0, y: self.view.bounds.height/2), end: CGPoint(x: self.view.bounds.width, y: self.view.bounds.height/2), lineColor: UIColor.black, view: self.view)

    }
    
    func colorSelectorValueChanged(sender: ColorSelector){
        self.delegate?.setColor(main: (mainColorSelector?.color)!, text: (textColorSelector?.color)!)
    }
    
    func drawLineFromPoint(start : CGPoint, end:CGPoint, lineColor: UIColor, view:UIView) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    
}
