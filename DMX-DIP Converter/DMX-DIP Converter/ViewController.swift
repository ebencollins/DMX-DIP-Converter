//
//  ViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/16.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var switchControl:DMXDIPSwitchControl?
    var keypadControl:DMXDIPKeypadControl?
    var outputLabel:UILabel?
    var outputView:UIView?
    var settingsButton:UIButton?
    
    let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.synchronize()
        
        switchControl = DMXDIPSwitchControl(frame: CGRect(x:0, y:0, width: 0, height: 0), invert: defaults.value(forKey: "invertDirection") as! Bool, labelTextMode: defaults.value(forKey: "switchLabels") as! Int, tColor: defaults.color(forKey: "swtColor")!, bColor: defaults.color(forKey: "swColor")!)
        switchControl?.addTarget(self, action: #selector(self.switchChanged(sender:)), for: .valueChanged)
        switchControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool
        
        keypadControl = DMXDIPKeypadControl(frame: CGRect(x: 0, y:0, width: 0, height:0), offsetInc: defaults.value(forKey: "offsetAmount") as! Int, tColor: defaults.color(forKey: "btColor")!, bColor: defaults.color(forKey: "bColor")!)
        keypadControl?.addTarget(self, action: #selector(self.buttonPressed(sender:)), for: .valueChanged)
        keypadControl?.backgroundColor = UIColor.black
        keypadControl?.enableHaptics = defaults.value(forKey: "enableHaptics") as! Bool
        
        outputLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outputLabel?.text = "0"
        outputLabel?.font = UIFont(name: (outputLabel?.font.fontName)!, size: (self.view.frame.height*0.15)/3.5)
        outputLabel?.backgroundColor = defaults.color(forKey: "oColor")!
        outputLabel?.textColor = defaults.color(forKey: "otColor")!
        outputLabel?.textAlignment = .right
        
        outputView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        outputView?.backgroundColor = outputLabel?.backgroundColor
        
        settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        settingsButton?.setImage(UIImage(named: "gear_64.png"), for: .normal)
        settingsButton?.addTarget(self, action: #selector(settingsButtonPress(sender:)), for: .touchUpInside)

        self.view.addSubview(outputView!)
        self.view.addSubview(outputLabel!)
        self.view.addSubview(switchControl!)
        self.view.addSubview(keypadControl!)
        self.view.addSubview(settingsButton!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        defaults.synchronize()
        defaults.checkDefaults()
        
        if defaults.value(forKey: "preventSleep") as! Bool{
            UIApplication.shared.isIdleTimerDisabled = true
        }else{
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        
    }
    override func viewDidLayoutSubviews() {
        outputView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.15)
        outputLabel?.frame = CGRect(x: 0, y: (outputView?.frame.height)! - (outputLabel?.font.pointSize)!, width: self.view.frame.width, height: (outputLabel?.font.pointSize)!)
        switchControl?.frame = CGRect(x: 0, y: (outputView?.frame.height)!, width: self.view.frame.width, height: 0.25 * self.view.frame.height)
        keypadControl?.frame = CGRect(x:0, y: (switchControl?.frame.height)! + (outputView?.frame.height)!, width: self.view.frame.width + 2, height: self.view.frame.height - ((outputView?.frame.height)! + (switchControl?.frame.height)!))
        settingsButton?.frame = CGRect(x: 8, y: 20, width: 32, height: 32)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    func settingsButtonPress(sender: UIButton){
        performSegue(withIdentifier: "mainToSettings", sender: nil)
    }
    
}
