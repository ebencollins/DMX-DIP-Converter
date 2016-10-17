//
//  ColorCustomizationViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/26.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit

class ColorCustomizationViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorSelectedViewDelegate{
    var mainView:DMXDIPView?
    var targetElement:Int = 0
    var colorKeys:(main: String, text: String)?
    
    override func viewDidLoad() {
        let ColorSelectorVC = ColorSelectorViewController()
        ColorSelectorVC.delegate = self
        
        
        mainView = DMXDIPView(frame: CGRect(x: 0, y:0, width: self.view.bounds.width, height: self.view.bounds.height), def: defaults, outputSize: 0.15, switchSize:0.25, keypadSize:0.6)
        mainView?.keypadControl?.removeTarget(nil, action: nil, for: .allEvents)
        mainView?.switchControl?.removeTarget(nil, action: nil, for: .allEvents)
        for b in (mainView?.keypadControl?.buttons)!{
            b.removeTarget(nil, action: nil, for: .allEvents)
            b.isUserInteractionEnabled = false
        }
        for sw in (mainView?.switchControl?.switches)!{
            sw.removeTarget(nil, action: nil, for: .allEvents)
            sw.isUserInteractionEnabled = false
        }
        mainView?.keypadControl?.addTarget(nil, action: #selector(keypadControlTUI(sender:)), for: .touchUpInside)
        mainView?.switchControl?.addTarget(nil, action: #selector(switchControlTUI(sender:)), for: .touchUpInside)
        mainView?.outputView?.addTarget(nil, action: #selector(outputViewTUI(sender:)), for: .touchUpInside)
        self.view.addSubview(mainView!)
    }
    
    override func viewDidLayoutSubviews() {
        mainView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
    }

    func setColor(main: UIColor, text:UIColor) {
        switch targetElement{
        case 0:
            mainView?.outputView?.backgroundColor = main
            mainView?.outputLabel?.backgroundColor = main
            mainView?.outputLabel?.textColor = text
            break
        case 1:
            mainView?.switchControl?.changeColors(mainColor: main, tColor: text)
            break
        case 2:
            mainView?.keypadControl?.changeColors(mainColor: main, tColor: text)
            break
        default:
            break
        }
        
    }

    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func keypadControlTUI(sender:Any){
        targetElement = 2
        colorKeys = ("bColor", "btColor")
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    func switchControlTUI(sender:Any){
        colorKeys = ("swColor", "swtColor")
        targetElement = 1
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    func outputViewTUI(sender:Any){
        colorKeys = ("oColor", "otColor")
        targetElement = 0
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ColorSelectorSegue"){
            let dest = segue.destination as! ColorSelectorViewController
            if let pop = dest.popoverPresentationController{
                pop.delegate = self
                switch targetElement{
                case 0:
                    dest.popoverPresentationController?.sourceRect = (mainView?.outputView?.frame)!
                    break
                case 1:
                    dest.popoverPresentationController?.sourceRect = (mainView?.switchControl?.frame)!
                    break
                case 2:
                    dest.popoverPresentationController?.sourceRect = (mainView?.keypadControl?.frame)!
                    break
                default:
                    break
                }
                dest.colorKeys = colorKeys
                dest.delegate = self
                
            }
        }
    }
}
