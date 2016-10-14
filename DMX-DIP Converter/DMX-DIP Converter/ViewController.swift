//
//  ViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/16.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var switchControl: DMXDIPSwitchControl!
    @IBOutlet weak var keypadControl: DMXDIPKeypadControl!
    @IBOutlet var mainView: UIView!
    
    @IBAction func switchControl(_ sender: Any) {
        let values = switchControl.switchValues
        let dmxValue = DMXDIP().dipsToNum(dips: values)
        outputLabel.text = String(dmxValue)
        keypadControl.value = dmxValue
        keypadControl.checkButtons(currentValue: keypadControl.value)
    }
    @IBAction func keypadControl(_ sender: Any) {
        outputLabel.text = String(keypadControl.value)
        switchControl.update(values: DMXDIP().numToDips(num: keypadControl.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.checkDefaults()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        UserDefaults.standard.checkDefaults()
        if defaults.value(forKey: "preventSleep") as! Bool{
            UIApplication.shared.isIdleTimerDisabled = true
        }else{
            UIApplication.shared.isIdleTimerDisabled = false
        }
        
        if !(defaults.value(forKey: "invertDirection") as! Bool){ //normal
            switchControl.offImage = UIImage(named: "customswitch_off.png")!
            switchControl.onImage = UIImage(named: "customswitch_on.png")!
            switchControl.directionalArrowImage = UIImage(named: "arrow_up_64.png")!
            switchControl.topLabelText = "ON"
            switchControl.bottomLabelText = "OFF"
        }else{ //invert
            switchControl.onImage = UIImage(named: "customswitch_off.png")!
            switchControl.offImage = UIImage(named: "customswitch_on.png")!
            switchControl.directionalArrowImage = UIImage(named: "arrow_down_64.png")!
            switchControl.topLabelText = "OFF"
            switchControl.bottomLabelText = "ON"
        }
        
        keypadControl.addGroupAmnt = defaults.value(forKey: "offsetAmount")! as! Int
        
        if(defaults.value(forKey: "enableHaptics") as! Bool){
            switchControl.enableHaptics = true
            keypadControl.enableHaptics = true
        }else{
            switchControl.enableHaptics = true
            keypadControl.enableHaptics = true
        }
        
        switch defaults.value(forKey: "switchLabels") as! Int{
        case 1:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(i + 1))
            }
            switchControl.switchLabelText = arr
            break
        case 2:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(describing: pow(2, i)))
            }
            switchControl.switchLabelText = arr
        default:
            var arr:[String] = []
            for i in 0..<9{
                arr.append(String(i))
            }
            switchControl.switchLabelText = arr
        }
        
        mainView.backgroundColor = defaults.color(forKey: "oColor")
        outputLabel.textColor = defaults.color(forKey: "otColor")
        keypadControl.buttonColor = defaults.color(forKey: "bColor")!
        keypadControl.textColor = defaults.color(forKey: "btColor")!
        switchControl.backgroundColor = defaults.color(forKey: "swColor")!
        switchControl.textColor = defaults.color(forKey: "swtColor")!
        
        switchControl.updateProperties()
        keypadControl.updateProperties()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
