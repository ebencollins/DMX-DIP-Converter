//
//  ColorCustomizationViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/26.
//  Copyright © 2016 Eben Collins. All rights reserved.
//

import UIKit

class ColorCustomizationViewController: UIViewController, UIPopoverPresentationControllerDelegate, ColorSelectedViewDelegate{
    
    var origin:UIView?
    var colorKey = ""
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var buttonText: UIButton!
    @IBOutlet weak var switchText: UIButton!
    @IBOutlet weak var outputText: UIButton!
    
    @IBAction func buttonText(_ sender: AnyObject) {
        origin = buttonText;
        colorKey = "btColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    @IBAction func switchText(_ sender: AnyObject) {
        origin = switchText;
        colorKey = "swtColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    @IBAction func outputText(_ sender: AnyObject) {
        origin = outputText;
        colorKey = "otColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    
    @IBAction func outputView(_ sender: AnyObject) {
        origin = displayView
        colorKey = "oColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    
    @IBAction func switchView(_ sender: AnyObject) {
        origin = switchView
        colorKey = "swColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    
    @IBAction func buttonView(_ sender: AnyObject) {
        origin = buttonsView
        colorKey = "bColor"
        self.performSegue(withIdentifier: "ColorSelectorSegue", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputText.setTitleColor(defaults.color(forKey: "otColor"), for: .normal)
        buttonText.setTitleColor(defaults.color(forKey: "btColor"), for: .normal)
        switchText.setTitleColor(defaults.color(forKey: "swtColor"), for: .normal)
        buttonsView.backgroundColor = defaults.color(forKey: "bColor")
        displayView.backgroundColor = defaults.color(forKey: "oColor")
        switchView.backgroundColor = defaults.color(forKey: "swColor")
        
        
        let ColorSelectorVC = ColorSelectorViewController()
        ColorSelectorVC.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ColorSelectorSegue"){
            let dest = segue.destination as! ColorSelectorViewController
            if let pop = dest.popoverPresentationController{
                pop.delegate = self
                dest.popoverPresentationController?.sourceRect = (origin?.bounds)!
                dest.colorKey = colorKey
                dest.delegate = self
                
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func setColor(color: UIColor) {
        switch colorKey{
        case "btColor":
            buttonText.setTitleColor(color, for: .normal)
            break
        case "otColor":
            outputText.setTitleColor(color, for: .normal)
            break
        case "swtColor":
            switchText.setTitleColor(color, for: .normal)
            break
        case "swColor":
            switchView.backgroundColor = color
            break
        case "oColor":
            displayView.backgroundColor = color
             break
        case "bColor":
            buttonsView.backgroundColor = color
            break
        default:
            break
        }
    }
    
    
}
