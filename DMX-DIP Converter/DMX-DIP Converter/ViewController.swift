//
//  ViewController.swift
//  DMX-DIP Converter
//
//  Created by Eben Collins on 16/07/16.
//  Copyright © 2016 collinseben. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var b11: UIButton!
    @IBOutlet weak var b12: UIButton!
    
    @IBOutlet weak var s0: UIButton!
    @IBOutlet weak var s1: UIButton!
    @IBOutlet weak var s2: UIButton!
    @IBOutlet weak var s3: UIButton!
    @IBOutlet weak var s4: UIButton!
    @IBOutlet weak var s5: UIButton!
    @IBOutlet weak var s6: UIButton!
    @IBOutlet weak var s7: UIButton!
    @IBOutlet weak var s8: UIButton!
    
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBOutlet weak var topDirectionlabel: UILabel!
    @IBOutlet weak var botDirectionlabel: UILabel!
    @IBOutlet weak var directionArrowImage: UIImageView!
    
    
    var switches:[UIButton] = [] //an array of the dip switches
    var buttons:[UIButton] = [] //an array holding all of the keypad buttons
    
    var buttonText:[String] = [] //an array holding the text that corresponds to the keypad button
    
    var dipArr:[Bool] = [] //holds active dips
    
    
    //settings:
    var addGroupAmnt = 16 //how much should the buttom left key increment by?
    var invertDipDirection:Bool = false;
    var onImage:UIImage?
    var offImage:UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDefaults()
        
        switches = [s0,s1,s2,s3,s4,s5,s6,s7,s8]
        buttons = [b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12]
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true);
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        checkDefaults()
        if defaults.value(forKey: "preventSleep") as! Bool{
            UIApplication.shared().isIdleTimerDisabled = true
        }else{
            UIApplication.shared().isIdleTimerDisabled = false
        }
        
        if defaults.value(forKey: "invertDirection") as! Bool{
            invertDipDirection = true;
        }else{
            invertDipDirection = false;
        }
        addGroupAmnt = defaults.value(forKey: "offsetAmount")! as! Int
        
        
        buttonText = ["+" + String(addGroupAmnt), "7", "4", "1", "0", "8", "5", "2", "\u{232B}", "9", "6", "3"] //add everything to the arrays
        
        if(invertDipDirection){
            onImage = UIImage(named:  "customswitch_off.png")
            offImage = UIImage(named: "customswitch_on.png")
            topDirectionlabel.text = "OFF"
            botDirectionlabel.text = "ON"
            directionArrowImage.image = UIImage(named: "arrow_down_64")
        }else{
            onImage = UIImage(named:  "customswitch_on.png")
            offImage = UIImage(named: "customswitch_off.png")
            topDirectionlabel.text = "ON"
            botDirectionlabel.text = "OFF"
            directionArrowImage.image = UIImage(named: "arrow_up_64")
        }
        
        
        for b in buttons{ //register the buttons for a touch up inside, set border/color/title
            b.setTitle(buttonText[buttons.index(of: b)!], for: .normal)
            b.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            b.layer.borderWidth = 1
            b.layer.borderColor = UIColor.lightGray().cgColor
        }
        
        dipArr.removeAll()
        for s in switches{ //same as above, but for dips
            s.addTarget(self, action: #selector(switchChanged), for: .touchUpInside) //touch drag inside as well?
            s.layer.borderWidth = 3
            s.layer.borderColor = UIColor.lightGray().cgColor
            dipArr.append(false)
        }
        setDips(dips: dipArr)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setDips(dips:[Bool]){ //set the dips based on a passed array
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
    
    func buttonTapped(sender: UIButton) { //handle the button press (for keypad)
        var value:String?
        var out = outputLabel.text!
        switch sender{
        case buttons[0]: //the +n button
            if var val = Int(out){
                val += addGroupAmnt
                if val > 511{
                    return
                }
                out = String(val)
            }else{
                print("Error incrementing")
            }
            break
        case buttons[8]: //delete
            if(out.characters.count > 1){
                out = out.substring(to: out.index(before: out.endIndex))
            }else{
                out = "0"
            }
            break
        default:
            value = buttonText[buttons.index(of: sender)!]
            if(out == "0"){
                out = value!
            }else{
                out.append(value!)
                if Int(out) > 511{ //prevent values from over 511 from being passed (max value per universe)
                    return
                }
            }
            break
        }
        outputLabel.text = out;
        //gray out buttons that can't be pressed and disable? here
        
        print("out is " + out)
        setDips(dips: numToDips(num: Int(out)!))
        
    }
    
    func switchChanged(sender:UIButton!){ //handle the dips being pressed
        let swIndex = switches.index(of: sender)!
        dipArr[swIndex] = !dipArr[swIndex]
        setDips(dips: dipArr)
        outputLabel.text = String((dipsToNum(dips: dipArr)))
    }
    
    
    func dipsToNum(dips:[Bool]) -> Int{ //input an array containing the values of the dips to return the integer address
        var finalNumber = 0
        for i in 0..<dips.count{
            if dips[i]{ //if the dip is active, add it's cooresponding power to the final output
                finalNumber += Int(pow(2.0, Double(i)))
            }
        }
        return finalNumber
    }
    
    func numToDips(num:Int) -> [Bool]{ //input a number, return an array of dips
        var dips:[Bool] = []
        var i:Double = Double(num)
        
        for _ in 0..<9{
            dips.append(false)
        }
        
        while i > 0{
            dips[Int(floor(log2(i)))] = true
            i -= pow(2.0, Double(floor(log2(i))))
        }
        return dips;
    }
    
}

func checkDefaults(){
    let defaults = UserDefaults.standard
    if(defaults.value(forKey: "preventSleep") == nil){
        defaults.set(true, forKey: "preventSleep")
    }
    if(defaults.value(forKey: "invertDirection") == nil){
        defaults.set(false, forKey: "invertDirection")
    }
    if(defaults.value(forKey: "offsetAmount") == nil){
        defaults.set(16, forKey: "offsetAmount")
    }
}
