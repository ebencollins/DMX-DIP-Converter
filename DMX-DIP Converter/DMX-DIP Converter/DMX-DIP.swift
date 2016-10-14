//
//  DMX-DIP.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 2016-08-16.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit
import Foundation

import UIKit

@IBDesignable class DMXDIPSwitchControl : UIControl{
    
    private var switches = [UIButton]()
    private var switchLabels = [UILabel]()
    private var arrowImg:UIImageView?
    private var topArrowLabel = UILabel()
    private var bottomArrowLabel = UILabel()
    
    
    var onImage = UIImage()
    var offImage = UIImage()
    var directionalArrowImage = UIImage()
    var topLabelText = "ON"
    var bottomLabelText = "OFF"
    
    var switchLabelText:[String]?
    var textColor = UIColor.white
    var backColor = UIColor(hue: 0, saturation: 0, brightness: 0.2, alpha: 1.0)
    var enableHaptics = true
    
    
    var switchValues:[Bool] = []
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
       
        for i in 0..<9{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            button.addTarget(self, action: #selector(DMXDIPSwitchControl.switchFlipped), for: .touchDown)
            button.setBackgroundImage(offImage, for: .normal)
            switches.append(button)
            addSubview(button)
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
            label.textColor = textColor
            label.text = switchLabelText != nil ? switchLabelText![i] : String(i)
            label.textAlignment = .center
            switchLabels.append(label)
            addSubview(label)
            
            switchValues.append(false);
        }
        
        arrowImg = UIImageView(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        arrowImg?.image = directionalArrowImage
        addSubview(arrowImg!)
        
        topArrowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        topArrowLabel.textAlignment = .center
        topArrowLabel.textColor = textColor
        topArrowLabel.text = topLabelText
        addSubview(topArrowLabel)
        
        bottomArrowLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        bottomArrowLabel.textAlignment = .center
        bottomArrowLabel.text = bottomLabelText
        bottomArrowLabel.textColor = textColor
        addSubview(bottomArrowLabel)
        
        backgroundColor = backColor
    }
    
    override func layoutSubviews() {
        let labelHeight = 24;
        let spacing:CGFloat = 4;
        let switchHeight = Int(frame.size.height) - labelHeight - Int(spacing)
        let switchWidth = Int((frame.size.width-4.0)/10) - Int(spacing)
        
        var switchFrame = CGRect(x: 0, y: Int(spacing), width: switchWidth, height: switchHeight)
        var labelFrame = CGRect(x: 0, y: switchHeight + Int(spacing), width: switchWidth, height: labelHeight)
        for (index, button) in switches.enumerated(){
            switchFrame.origin.x = CGFloat(index) * (switchFrame.width) + 2 + CGFloat(index) * spacing
            button.frame = switchFrame
        }
        for(index, label) in switchLabels.enumerated(){
            labelFrame.origin.x = CGFloat(index) * (labelFrame.width) + 2 + CGFloat(index) * spacing
            label.frame = labelFrame
        }
        
        let arrowImgX = 9 * (labelFrame.width + spacing) - 1
        let arrowH = frame.size.height - 48 < 64 ? 0.5 * (frame.size.height - 48) : 64
        arrowImg?.frame = CGRect(x: arrowImgX, y: CGFloat((switchHeight-Int(arrowH))/2), width: frame.size.width - arrowImgX, height: arrowH)
        
        var bottomArrowLabelFrame = CGRect(x: arrowImgX, y: 0, width: frame.size.width - arrowImgX, height: 24)
        bottomArrowLabelFrame.origin.y = CGFloat(switchHeight + Int(spacing) - 24)
        bottomArrowLabel.frame = bottomArrowLabelFrame
        
        topArrowLabel.frame = CGRect(x: arrowImgX, y: 0, width: frame.size.width - arrowImgX, height: 24)
    }
    
    override var intrinsicContentSize:CGSize {
        return CGSize(width: 240, height: 44)
    }
    
    func switchFlipped(sender: UIButton){
        if(enableHaptics){
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
        let i = switches.index(of: sender)
        switchValues[i!] = !switchValues[i!]
        update(values: switchValues)
    }
    
    func update(values: [Bool]){
        for i in 0..<values.count{
            let sw = switches[i]
            if(values[i]){
                sw.setBackgroundImage(onImage, for: .normal)
            }else{
                sw.setBackgroundImage(offImage, for: .normal)
            }
            switchValues[i] = values[i];
        }
        
        sendActions(for: UIControlEvents.valueChanged)
    }
    
    func updateProperties(){
        for i in 0..<switchLabels.count{
            switchLabels[i].textColor = textColor
            switchLabels[i].text = switchLabelText?[i]
        }
        topArrowLabel.textColor = textColor
        bottomArrowLabel.textColor = textColor
        
        topArrowLabel.text = topLabelText
        bottomArrowLabel.text = bottomLabelText;
        arrowImg?.image = directionalArrowImage
        for i in 0..<9{
            if(switchValues[i]){
                switches[i].setBackgroundImage(onImage, for: .normal)
            }else{
                switches[i].setBackgroundImage(offImage, for: .normal)
            }
        }
    }

}


@IBDesignable class DMXDIPKeypadControl: UIControl {
    // MARK: Properties
    
    var buttons = [UIButton]()
    
    var buttonLabels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "", "0", "\u{232B}"]
    var textColor = UIColor.white
    var buttonColor = UIColor.black
    var enableHaptics = true;
    
    var maxValue:Int = 511;
    var addGroupAmnt:Int = 8;
    
    var value:Int = 0;
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    // MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buttonLabels[9] = "+" + String(addGroupAmnt)
        backgroundColor = UIColor.black
        for i in 0..<12{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            button.backgroundColor = buttonColor
            button.setTitle(buttonLabels[i], for: .normal)
            button.addTarget(self, action: #selector(DMXDIPKeypadControl.buttonTapped), for: .touchDown)
            button.layer.borderWidth = 0.5
            button.layer.borderColor = textColor.cgColor
            button.adjustsImageWhenHighlighted = true
            button.adjustsImageWhenDisabled = true
            button.showsTouchWhenHighlighted = true
            buttons.append(button)
            addSubview(button)
        }
        
    }
    
    override func layoutSubviews() {
        
        let buttonHeight = Int(frame.size.height/4)
        let buttonWidth = Int(frame.size.width/3)
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        for(index, button) in buttons.enumerated(){
            buttonFrame.origin.x = CGFloat(index % 3 * buttonWidth)
            if(index % 3 == 0){
                buttonFrame.origin.y = CGFloat(buttonHeight) * CGFloat(floor(Double(index)/3));
            }
            button.frame = buttonFrame
        }
    }
    
    override var intrinsicContentSize:CGSize {
        return CGSize(width: 240, height: 44)
    }
    
    func updateProperties(){
        buttonLabels[9] = "+" + String(addGroupAmnt)
        for i in 0..<buttons.count{
            buttons[i].backgroundColor = buttonColor
            buttons[i].layer.borderColor = textColor.cgColor
            buttons[i].setTitleColor(textColor, for: .normal)
            buttons[i].setTitle(buttonLabels[i], for: .normal)
        }
    }
    
    func buttonTapped(sender: UIButton) {
        if(enableHaptics){
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
        switch sender{
        case buttons[9]: //the +n button
            value += addGroupAmnt
            break
        case buttons[11]: //delete
            var valueStr = String(value)
            if(valueStr.characters.count > 1){
                valueStr = valueStr.substring(to: valueStr.index(before: valueStr.endIndex))
                value = Int(valueStr)!
            }else{
                value = 0
            }
            break
        default:
            let val = buttonLabels[buttons.index(of: sender)!]
            if(value == 0){
                value = Int(val)!;
            }else{
                value = Int(String(value) + (val))!
            }
            break
        }
        checkButtons(currentValue: value)
        sendActions(for: UIControlEvents.valueChanged)
    }
    
    func checkButtons(currentValue: Int){ //check to see what butons can be pressed without putting the number above what is specified; disable the rest
        for i in 0..<buttons.count{
            var disable:Bool = false;
            if i == 9{ //inc
                if currentValue + addGroupAmnt > maxValue{
                    disable = true;
                }
            }else if i == 11{ //del
                continue
            }else{
                if Int(buttonLabels[i]) != nil{
                    if(Int(String(currentValue) + buttonLabels[i])! > maxValue){
                        disable = true;
                    }
                }
            }
            if(disable){
                buttons[i].isEnabled = false;
                buttons[i].alpha = 0.25;
            }else{
                buttons[i].isEnabled = true;
                buttons[i].alpha = 1.0;
            }
        }
        
    }
    
    
}


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

func selectionFeedback(){
    if(UserDefaults.standard.value(forKey: "enableHaptics") as! Bool){
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
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
        var color: UIColor? = UIColor.clear
        if let colorData = data(forKey: forKey) {
            color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
        }
        return color
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        var colorData: NSData?
        if let color = color {
            colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData?
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
            defaults.setColor(color: UIColor.white, forKey: "btColor")
        }
        if(defaults.value(forKey: "swtColor") == nil){
            defaults.setColor(color: UIColor.white, forKey: "swtColor")
        }
        if(defaults.value(forKey: "otColor") == nil){
            defaults.setColor(color: UIColor.white, forKey: "otColor")
        }
        if(defaults.value(forKey: "bColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.1, alpha: 1.0), forKey: "bColor")
        }
        if(defaults.value(forKey: "swColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.21, alpha: 1.0), forKey: "swColor")
        }
        if(defaults.value(forKey: "oColor") == nil){
            defaults.setColor(color: UIColor(hue:0, saturation: 0, brightness: 0.1, alpha: 1.0), forKey: "oColor")
        }
        
        if(defaults.value(forKey: "enableHaptics") == nil){
            defaults.setValue(true, forKey: "enableHaptics")
        }
        
        
        
    }
}
