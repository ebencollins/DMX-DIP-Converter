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
        var mainView: DMXDIPView?
        
        let defaults = UserDefaults(suiteName: "group.com.ebencollins.DMXDIPConverter.share")!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
           
            defaults.synchronize()
            defaults.checkDefaults()
            
            if self.extensionContext?.widgetActiveDisplayMode == NCWidgetDisplayMode.compact{
                mainView = DMXDIPView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height), def: defaults, outputSize: 0.15, switchSize:0.25, keypadSize:0.0, fSize: 20)
            }else{
                mainView = DMXDIPView(frame: CGRect(x: 0, y:0, width: self.view.frame.width, height: self.view.frame.height), def: defaults, outputSize: 0.05, switchSize:0.25, keypadSize:0.7, fSize: 24)
            }
            
            self.view.addSubview(mainView!)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true);
            self.viewDidLoad()
            mainView?.resetValues()
        }
        override func viewDidLayoutSubviews() {
            mainView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        mainView?.resetValues()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 320, height: 400) : CGSize(width: maxSize.width, height: maxSize.height)
        mainView?.keypadControlHeight = activeDisplayMode == .expanded ? 0.7 : 0
        mainView?.layoutSubviews()
    }
    
}
