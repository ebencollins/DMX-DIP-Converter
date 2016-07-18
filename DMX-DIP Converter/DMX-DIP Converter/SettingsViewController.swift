//
//  SettingsViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/17.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit

var defaults = UserDefaults.standard

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var preventSleepSC: UISegmentedControl!
    @IBOutlet weak var invertDipDirection: UISegmentedControl!
    @IBOutlet weak var incAmount: UISegmentedControl!
    
    @IBOutlet weak var restoreDefaults: UIButton!
    
    
    @IBAction func preventSleepSC(_ sender: AnyObject) {
        switch preventSleepSC.selectedSegmentIndex{
        case 0:
            defaults.setValue(true, forKey: "preventSleep")
        case 1:
            defaults.setValue(false, forKey: "preventSleep")
        default:
            break
        }
    }
    
    @IBAction func invertDipDirection(_ sender: AnyObject) {
        switch invertDipDirection.selectedSegmentIndex{
        case 0:
            defaults.setValue(false, forKey: "invertDirection")
        case 1:
            defaults.setValue(true, forKey: "invertDirection")
        default:
            break
        }
    }
    
    @IBAction func incAmount(_ sender: AnyObject) {
        switch incAmount.selectedSegmentIndex{
        case 0:
            defaults.setValue(4, forKey: "offsetAmount")
        case 1:
            defaults.setValue(8, forKey: "offsetAmount")
        case 2:
            defaults.setValue(16, forKey: "offsetAmount")
        case 3:
            var inputTextField: UITextField?
            
            let alertController: UIAlertController = UIAlertController(title: "Set Custom Offset", message: "", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                
            }
            alertController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "Done", style: .default) { action -> Void in
                defaults.setValue(Int((inputTextField?.text!)!), forKey: "offsetAmount")
                self.viewDidLoad()
                
            }
            alertController.addAction(nextAction)
            alertController.addTextField { textField -> Void in
                
                inputTextField = textField
                inputTextField?.placeholder = String(defaults.value(forKey: "offsetAmount")! as! Int )
                inputTextField?.keyboardType = .numberPad
            }
            
            self.present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func restoreDefaults(_ sender: AnyObject) {
        let confirmationPopup = UIAlertController(title: "Reset all settings?", message: "All settigns will be restored to default. This action is not reversible.", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmationPopup.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: {(action: UIAlertAction!) in
            for key in Array(defaults.dictionaryRepresentation().keys) {
                defaults.removeObject(forKey: key)
            }
            checkDefaults()
            
            self.viewDidLoad()
        }))
        
        confirmationPopup.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
            
        }))
        
        present(confirmationPopup, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkDefaults()
        
        preventSleepSC.setTitle("ENABLED", forSegmentAt: 0)
        preventSleepSC.setTitle("DISABLED", forSegmentAt: 1)
        if defaults.value(forKey: "preventSleep") as! Bool{
            preventSleepSC.selectedSegmentIndex=0
        }else{
            preventSleepSC.selectedSegmentIndex=1
        }
        
        invertDipDirection.setTitle("DOWN", forSegmentAt: 1)
        invertDipDirection.setTitle("UP", forSegmentAt: 0)
        if defaults.value(forKey: "invertDirection") as! Bool{
            invertDipDirection.selectedSegmentIndex=1
        }else{
            invertDipDirection.selectedSegmentIndex=0
        }
        
        incAmount.setTitle("+4", forSegmentAt: 0);
        incAmount.setTitle("+8", forSegmentAt: 1);
        let customTxt:String = String(defaults.value(forKey: "offsetAmount")! as! Int )
        if(incAmount.numberOfSegments < 4){
            incAmount.insertSegment(withTitle: "+16", at: 2, animated: false);
            incAmount.insertSegment(withTitle:"Custom (+" + customTxt + ")", at: 3, animated: false);
        }else{
            incAmount.setTitle("+16", forSegmentAt: 2);
            incAmount.setTitle("Custom (+" + customTxt + ")", forSegmentAt: 3);
        }
        for i in 0...2{
            incAmount.setWidth(UIScreen.main().bounds.width/5, forSegmentAt: i)
        }
        incAmount.setWidth(2 * UIScreen.main().bounds.width/5, forSegmentAt: 3)
        
        
        switch defaults.value(forKey: "offsetAmount") as! Int{
        case 4:
            incAmount.selectedSegmentIndex = 0
            break;
        case 8:
            incAmount.selectedSegmentIndex = 1
            break;
        case 16:
            incAmount.selectedSegmentIndex = 2
            break;
        default:
            incAmount.selectedSegmentIndex = 3
            break
        }
        
        
    }
    
    
}