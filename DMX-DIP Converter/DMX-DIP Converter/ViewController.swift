//
//  ViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/16.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var mainView: DMXDIPView?
    var settingsButton:UIButton?
    
    let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMX-DIP-Converter.share")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaults.synchronize()
        defaults.checkDefaults()
        
        mainView = DMXDIPView(frame: CGRect(x: 0, y:0, width: self.view.bounds.width, height: self.view.bounds.height), def: defaults, outputSize: 0.15, switchSize:0.25, keypadSize:0.6)

        
        settingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        settingsButton?.setImage(UIImage(named: "gear_64.png"), for: .normal)
        settingsButton?.addTarget(self, action: #selector(settingsButtonPress(sender:)), for: .touchUpInside)

        self.view.addSubview(mainView!)
        self.view.addSubview(settingsButton!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.viewDidLoad()
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
        mainView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        settingsButton?.frame = CGRect(x: 8, y: 20, width: 40, height: 40)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func settingsButtonPress(sender: UIButton){
        performSegue(withIdentifier: "mainToSettings", sender: nil)
    }
    
}
