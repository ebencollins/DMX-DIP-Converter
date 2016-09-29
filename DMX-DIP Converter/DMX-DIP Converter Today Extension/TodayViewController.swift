//
//  TodayViewController.swift
//  DMX-DIP Converter Today Extension
//
//  Created by Eben Collins on 2016-08-2.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var outputButton: UIButton!
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var s0: UIButton!
    @IBOutlet weak var s1: UIButton!
    @IBOutlet weak var s2: UIButton!
    @IBOutlet weak var s3: UIButton!
    @IBOutlet weak var s4: UIButton!
    @IBOutlet weak var s5: UIButton!
    @IBOutlet weak var s6: UIButton!
    @IBOutlet weak var s7: UIButton!
    @IBOutlet weak var s8: UIButton!
    
    var switches:[UIButton] = []
    var dipArr:[Bool] = []
    
    let onImage = UIImage(named:  "customswitch_on.png")
    let offImage = UIImage(named: "customswitch_off.png")
    
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switches = [s0, s1, s2, s3, s4, s5, s6, s7, s8]
        for s in switches{
            s.addTarget(self, action: #selector(switchChanged), for: .touchUpInside)
            s.layer.borderWidth = 3
            s.layer.borderColor = UIColor.clear.cgColor
            dipArr.append(false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        self.preferredContentSize.width = UIScreen.main.bounds.width * 1.0
        self.preferredContentSize.height = UIScreen.main.bounds.width * 0.75
        
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        setDips(dips: [false, false, false, false, false, false, false, false])
        completionHandler(NCUpdateResult.newData)
    }
    
    
    
    
    func switchChanged(sender:UIButton!){ //handle the dips being pressed
        let swIndex = switches.index(of: sender)!
        dipArr[swIndex] = !dipArr[swIndex]
        setDips(dips: dipArr)
        outputLabel.text = String((DMXDIP().dipsToNum(dips: dipArr)))
    }
    
    func setDips(dips:[Bool]){
        print("dips are ")
        print(dips)
        for i in 0..<dips.count{
            let sw = switches[i]
            if(dips[i]){
                sw.setBackgroundImage(onImage, for: .normal)
            }else{
                sw.setBackgroundImage(offImage, for: .normal)
            }
            
            dipArr[i] = dips[i];
        }
        
    }
    
    @IBAction func outputButton(_ sender: AnyObject) {
        let url : NSURL = NSURL(string: "DMX-DIP-Converter://")!
        self.extensionContext?.open(url as URL, completionHandler: nil)
    }
}
