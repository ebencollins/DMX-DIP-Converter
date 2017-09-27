//
//  SettingsViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/17.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit
import LicensesKit

let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMXDIPConverter.share")!

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var preventSleepSC: UISegmentedControl!
    @IBOutlet weak var hapticsSC: UISegmentedControl!
    @IBOutlet weak var invertDipDirection: UISegmentedControl!
    @IBOutlet weak var incAmount: UISegmentedControl!
    @IBOutlet weak var switchLabels: UISegmentedControl!
    
    @IBOutlet weak var restoreDefaults: UIButton!
    
    
    @IBAction func preventSleepSC(_ sender: AnyObject) {
        selectionFeedback()
        switch preventSleepSC.selectedSegmentIndex{
        case 0:
            defaults.setValue(true, forKey: "preventSleep")
        case 1:
            defaults.setValue(false, forKey: "preventSleep")
        default:
            break
        }
    }
    
    @IBAction func hapticsSC(_ sender: AnyObject) {
        selectionFeedback()
        switch hapticsSC.selectedSegmentIndex{
        case 0:
            defaults.setValue(true, forKey: "enableHaptics")
        case 1:
            defaults.setValue(false, forKey: "enableHaptics")
        default:
            break
        }
    }
    @IBAction func invertDipDirection(_ sender: AnyObject) {
        selectionFeedback()
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
            selectionFeedback()
            defaults.setValue(4, forKey: "offsetAmount")
        case 1:
            selectionFeedback()
            defaults.setValue(8, forKey: "offsetAmount")
        case 2:
            selectionFeedback()
            defaults.setValue(16, forKey: "offsetAmount")
        case 3:
            if(defaults.value(forKey: "enableHaptics") as! Bool){
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            }
            var inputTextField: UITextField?
            
            let alertController: UIAlertController = UIAlertController(title: "Set Custom Offset", message: "", preferredStyle: .alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                
            }
            alertController.addAction(cancelAction)
            let nextAction: UIAlertAction = UIAlertAction(title: "Done", style: .default) { action -> Void in
                selectionFeedback()
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
        if(defaults.value(forKey: "enableHaptics") as! Bool){
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
        let confirmationPopup = UIAlertController(title: "Reset all settings?", message: "All settigns will be restored to default. This action is not reversible.", preferredStyle: UIAlertControllerStyle.alert)
        
        confirmationPopup.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: {(action: UIAlertAction!) in
            if(defaults.value(forKey: "enableHaptics") as! Bool){
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            }
            for key in Array(defaults.dictionaryRepresentation().keys) {
                defaults.removeObject(forKey: key)
            }
            defaults.synchronize()
            defaults.checkDefaults()
            
            self.viewDidLoad()
        }))
        
        confirmationPopup.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction!) in
            
        }))
        
        present(confirmationPopup, animated: true, completion: nil)
    }
    
    @IBAction func switchLabels(_ sender: AnyObject) {
        selectionFeedback()
        switch switchLabels.selectedSegmentIndex{
        case 0:
            defaults.setValue(0, forKey: "switchLabels")
        case 1:
            defaults.setValue(1, forKey: "switchLabels")
        case 2:
            defaults.setValue(2, forKey: "switchLabels")
        default:
            break
        }
    
    
    }
    
    @IBAction func acknowledgementsButton(_ sender: AnyObject) {
        let licensesViewController = LicensesViewController()
        licensesViewController.addNotice(Notice(name: "GradientSlider", url: "https://github.com/jonhull/GradientSlider", copyright: "Copyright (c) 2015 Jonathan Hull", license: MITLicense()))
        licensesViewController.addNotice(Notice(name: "LicensesKit", url: "https://github.com/mattwyskiel/LicensesKit", copyright: "Copyright 2015 Matthew Wyskiel. All rights reserved.", license: ApacheSoftwareLicense20()))
        licensesViewController.pageHeader = "<center><h2>Third Party Code Used in this Application </h2></center>"
//        present(licensesViewController, animated: true)
        let navCont = UINavigationController(rootViewController: licensesViewController)
        licensesViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(closeViewController))
        present(navCont, animated: true, completion: nil)
    }
    @IBAction func githubButton(_ sender: AnyObject) {
        openURL(URLString: "https://github.com/Zahzi/DMX-DIP-Converter")
    }
    
    @IBAction func issuesButton(_ sender: AnyObject) {
        openURL(URLString: "https://github.com/Zahzi/DMX-DIP-Converter/issues/new")
    }
    
    @IBAction func licenseButton(_ sender: AnyObject) {
        openURL(URLString: "https://raw.githubusercontent.com/Zahzi/DMX-DIP-Converter/master/LICENSE")
    }
    
    func closeViewController(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.synchronize()
        defaults.checkDefaults()
        
        preventSleepSC.setTitle("ENABLED", forSegmentAt: 0)
        preventSleepSC.setTitle("DISABLED", forSegmentAt: 1)
        if defaults.value(forKey: "preventSleep") as! Bool{
            preventSleepSC.selectedSegmentIndex=0
        }else{
            preventSleepSC.selectedSegmentIndex=1
        }
        
        hapticsSC.setTitle("ENABLED", forSegmentAt: 0)
        hapticsSC.setTitle("DISABLED", forSegmentAt: 1)
        if defaults.value(forKey: "enableHaptics") as! Bool{
            hapticsSC.selectedSegmentIndex=0
        }else{
            hapticsSC.selectedSegmentIndex=1
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
            incAmount.setWidth(UIScreen.main.bounds.width/5, forSegmentAt: i)
        }
        incAmount.setWidth(2 * UIScreen.main.bounds.width/5, forSegmentAt: 3)
        
        switchLabels.setTitle("Exponent", forSegmentAt: 0);
        switchLabels.setTitle("Number", forSegmentAt: 1);
        if switchLabels.numberOfSegments < 3{
            switchLabels.insertSegment(withTitle: "Address", at: 2, animated: false);
        }else{
            switchLabels.setTitle("Address", forSegmentAt: 2);
        }
        
        
        switch defaults.value(forKey: "switchLabels") as! Int{
        case 0:
            switchLabels.selectedSegmentIndex = 0
            break;
        case 1:
            switchLabels.selectedSegmentIndex = 1
            break;
        case 2:
            switchLabels.selectedSegmentIndex = 2
            break;
        default:
            break;
        }
        
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
    
    func openURL(URLString:String){
        guard let url = URL(string: URLString) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        defaults.synchronize()
    }
    
    
}
