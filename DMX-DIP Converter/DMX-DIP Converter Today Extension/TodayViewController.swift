//
//  TodayViewController.swift
//  DMX-DIP Converter Today Extension
//
//  Created by Eben Collins on 2016-08-2.
//  Copyright © 2016 collinseben. All rights reserved.
//
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
        

        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        
        switches = [s0, s1, s2, s3, s4, s5, s6, s7, s8]
        for s in switches{
            s.addTarget(self, action: #selector(switchChanged), for: .touchUpInside)
            s.layer.borderWidth = 3
            s.layer.borderColor = UIColor.clear.cgColor
            dipArr.append(false)
        }
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
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
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

    @available(iOS 10.0, *)
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 320, height: 400) : CGSize(width: maxSize.width, height: maxSize.height)
    }
}
