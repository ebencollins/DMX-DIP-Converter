//
//  TodayViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 2016-10-14.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var switchControl:DMXDIPSwitchControl?
    var keypadControl:DMXDIPKeypadControl?
    var outputLabel:UILabel?
    
    let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.synchronize()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        switchControl = DMXDIPSwitchControl(frame: CGRect(x:0, y:0, width: 0, height: 0), invert: defaults.value(forKey: "invertDirection") as! Bool, labelTextMode: defaults.value(forKey: "switchLabels") as! Int, tColor: defaults.color(forKey: "swtColor")!, bColor: defaults.color(forKey: "swColor")!)
        switchControl?.addTarget(self, action: #selector(self.switchChanged(sender:)), for: .valueChanged)
        switchControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool
        
        keypadControl = DMXDIPKeypadControl(frame: CGRect(x: 0, y:0, width: 0, height:0), tColor: defaults.color(forKey: "btColor")!, bColor: defaults.color(forKey: "bColor")!)
        keypadControl?.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .valueChanged)
        keypadControl?.backgroundColor = UIColor.black
        keypadControl?.addGroupAmnt = defaults.value(forKey: "offsetAmount") as! Int
        keypadControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool
        
        outputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outputLabel?.text = "0"
        outputLabel?.backgroundColor = defaults.color(forKey: "oColor")!
        outputLabel?.textColor = defaults.color(forKey: "otColor")!
        outputLabel?.textAlignment = .right
        
        
        self.view.addSubview(outputLabel!)
        self.view.addSubview(switchControl!)
        self.view.addSubview(keypadControl!)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        resetValues()
    }
    
    override func viewDidLayoutSubviews() {
        if self.extensionContext?.widgetActiveDisplayMode == NCWidgetDisplayMode.compact{
            outputLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 24)
            switchControl?.frame = CGRect(x: 0, y: (outputLabel?.frame.height)!, width: self.view.frame.width, height: self.view.frame.height - (outputLabel?.frame.height)!)
        }else{
            outputLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 24)
            switchControl?.frame = CGRect(x: 0, y: (outputLabel?.frame.height)!, width: self.view.frame.width, height: 0.3 * self.view.frame.height)
            keypadControl?.frame = CGRect(x:-1, y: (switchControl?.frame.height)! + (outputLabel?.frame.height)! - 1, width: self.view.frame.width + 2, height: self.view.frame.height - ((outputLabel?.frame.height)! + (switchControl?.frame.height)!) + 4)
        }
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        resetValues()
        completionHandler(NCUpdateResult.newData)
    }
    
    func resetValues(){
        outputLabel?.text = "0"
        keypadControl?.value = 0
        switchControl?.switchValues = [false, false, false, false, false, false, false, false, false]
        switchControl?.update(values: (switchControl?.switchValues)!)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 320, height: 400) : CGSize(width: maxSize.width, height: maxSize.height)
        self.viewDidLayoutSubviews()
    }
    
}
