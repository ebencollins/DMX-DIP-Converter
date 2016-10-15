//
//  DMX-DIP.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 2016-08-16.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit
import Foundation


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
    
    init(frame: CGRect, invert: Bool, labelTextMode:Int, tColor: UIColor, bColor: UIColor){
        print("init custom")
        textColor = tColor
        backColor = bColor
        switch labelTextMode{
        case 1:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(i + 1))
            }
            self.switchLabelText = arr
            break
        case 2:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(describing: pow(2, i)))
            }
            self.switchLabelText = arr
        default:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(i))
            }
            self.switchLabelText = arr
        }
        
        if(invert){
            onImage = UIImage(named: "customswitch_off.png")!
            offImage = UIImage(named: "customswitch_on.png")!
            directionalArrowImage = UIImage(named: "arrow_down_64.png")!
            topLabelText = "OFF"
            bottomLabelText = "ON"
        }else{
            onImage = UIImage(named: "customswitch_on.png")!
            offImage = UIImage(named: "customswitch_off.png")!
            directionalArrowImage = UIImage(named: "arrow_up_64.png")!
            topLabelText = "ON"
            bottomLabelText = "OFF"
        }
        super.init(frame: frame)
        commonSetup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        print("init frame")
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        print("init coder")
        commonSetup()
        
    }
    
    func commonSetup(){
        print("commonSetup")
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
        let switchHeight = Int(bounds.size.height) - labelHeight - Int(spacing)
        let switchWidth = Int((bounds.size.width-4.0)/10) - Int(spacing)
        
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
        let arrowH = bounds.size.height - 48 < 64 ? 0.5 * (bounds.size.height - 48) : 64
        arrowImg?.frame = CGRect(x: arrowImgX, y: CGFloat((switchHeight-Int(arrowH))/2), width: bounds.size.width - arrowImgX, height: arrowH < 32 ? 0 : arrowH)
        
        var bottomArrowLabelFrame = CGRect(x: arrowImgX, y: 0, width: bounds.size.width - arrowImgX, height: 24)
        bottomArrowLabelFrame.origin.y = CGFloat(switchHeight + Int(spacing) - 24)
        bottomArrowLabel.frame = bottomArrowLabelFrame
        
        topArrowLabel.frame = CGRect(x: arrowImgX, y: 0, width: bounds.size.width - arrowImgX, height: 24)
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
    
    func changeColors(mainColor: UIColor, tColor: UIColor){
        backColor = mainColor
        textColor = tColor
        backgroundColor = backColor
        for label in switchLabels{
            label.textColor = textColor
        }
        topArrowLabel.textColor = textColor
        bottomArrowLabel.textColor = textColor
        
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
    
    // MARK: Initialization
    init(frame: CGRect, offsetInc:Int, tColor: UIColor, bColor: UIColor){
        textColor = tColor
        buttonColor = bColor
        addGroupAmnt = offsetInc
        
        super.init(frame: frame)
        commonSetup()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
        
    }
    func commonSetup(){
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
        
        let buttonHeight = Int(bounds.size.height/4)
        let buttonWidth = Int(bounds.size.width/3)
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
    
    func changeColors(bColor: UIColor, tColor:UIColor){
        buttonColor = bColor
        textColor = tColor
        for b in buttons{
            b.backgroundColor = bColor
            b.setTitleColor(tColor, for: .normal)
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


@IBDesignable class DMXDIPView: UIView{
    
    var defaults:UserDefaults = UserDefaults.standard
    
    var switchControl:DMXDIPSwitchControl?
    var keypadControl:DMXDIPKeypadControl?
    var outputLabel:UILabel?
    var outputView:UIView?
       
    
    var outputViewHeight:CGFloat = 0.15
    var switchControlHeight:CGFloat = 0.25
    var keypadControlHeight:CGFloat = 0.6
    var fontSize:CGFloat?
    
    
    // MARK: Initialization
   init(frame: CGRect, def: UserDefaults, outputSize:CGFloat, switchSize:CGFloat, keypadSize:CGFloat){
        defaults = def
        outputViewHeight = outputSize
        switchControlHeight = switchSize
        keypadControlHeight = keypadSize
        super.init(frame: frame)
        load()
    }
    
    init(frame: CGRect, def: UserDefaults, outputSize:CGFloat, switchSize:CGFloat, keypadSize:CGFloat, fSize:CGFloat){
        fontSize = fSize
        defaults = def
        outputViewHeight = outputSize
        switchControlHeight = switchSize
        keypadControlHeight = keypadSize
        super.init(frame: frame)
        load()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load()
        
    }
    func load(){
        defaults.synchronize()
        defaults.checkDefaults()
        
        switchControl = DMXDIPSwitchControl(frame: CGRect(x:0, y:0, width: 0, height: 0), invert: defaults.value(forKey: "invertDirection") as! Bool, labelTextMode: defaults.value(forKey: "switchLabels") as! Int, tColor: defaults.color(forKey: "swtColor")!, bColor: defaults.color(forKey: "swColor")!)
        switchControl?.addTarget(self, action: #selector(self.switchChanged(sender:)), for: .valueChanged)
        switchControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool
        
        keypadControl = DMXDIPKeypadControl(frame: CGRect(x: 0, y:0, width: 0, height:0), offsetInc: defaults.value(forKey: "offsetAmount") as! Int, tColor: defaults.color(forKey: "btColor")!, bColor: defaults.color(forKey: "bColor")!)
        keypadControl?.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .valueChanged)
        keypadControl?.backgroundColor = UIColor.black
        keypadControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool

        outputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outputLabel?.text = "0"
        outputLabel?.font = UIFont(name: (outputLabel?.font.fontName)!, size: fontSize != nil ? fontSize! : (outputViewHeight * frame.height)/3.5)
        outputLabel?.backgroundColor = defaults.color(forKey: "oColor")!
        outputLabel?.textColor = defaults.color(forKey: "otColor")!
        outputLabel?.textAlignment = .right
        
        outputView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outputView?.backgroundColor = outputLabel?.backgroundColor
        
        addSubview(outputView!)
        addSubview(outputLabel!)
        addSubview(switchControl!)
        addSubview(keypadControl!)
    }
    
    override func layoutSubviews() {
        outputView?.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * outputViewHeight < (outputLabel?.font.pointSize)! ? (outputLabel?.font.pointSize)! : bounds.height * outputViewHeight)
        outputLabel?.frame = CGRect(x: 0, y: (outputView?.bounds.height)! - (outputLabel?.font.pointSize)!, width: bounds.width, height: (outputLabel?.font.pointSize)!)
        if keypadControlHeight != 0{
            switchControl?.frame = CGRect(x: 0, y: (outputView?.bounds.height)!, width: bounds.width, height: switchControlHeight * bounds.height)
            keypadControl?.frame = CGRect(x:0, y: (switchControl?.bounds.height)! + (outputView?.bounds.height)!, width: bounds.width, height: bounds.height - ((outputView?.bounds.height)! + (switchControl?.bounds.height)!))
        }else{
            switchControl?.frame = CGRect(x: 0, y: (outputView?.bounds.height)!, width: bounds.width, height: bounds.height - (outputView?.bounds.height)!)
            keypadControl?.frame = CGRect(x: -5, y: -5, width: 0, height: 0)
        }
    }
    
    override var intrinsicContentSize:CGSize {
        return CGSize(width: 240, height: 44)
    }
    
    func buttonPressed(sender: DMXDIPKeypadControl){
        outputLabel?.text = String(describing: keypadControl?.value)
        switchControl?.update(values: DMXDIP().numToDips(num: (keypadControl?.value)!))
    }
    
    func switchChanged(sender: DMXDIPSwitchControl){
        let values = switchControl?.switchValues
        let dmxValue = DMXDIP().dipsToNum(dips: values!)
        outputLabel?.text = String(dmxValue)
        keypadControl?.value = dmxValue
        keypadControl?.checkButtons(currentValue: (keypadControl?.value)!)
    }
    
    func resetValues(){
        outputLabel?.text = "0"
        keypadControl?.value = 0
        switchControl?.switchValues = [false, false, false, false, false, false, false, false, false]
        switchControl?.update(values: (switchControl?.switchValues)!)
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
    let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
    if(defaults.value(forKey: "enableHaptics") as! Bool){
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
        let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
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
        
        defaults.synchronize()
        
        
    }
}
