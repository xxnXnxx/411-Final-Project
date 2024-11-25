//
//  ViewController.swift
//  Coding Clicker
//
//  Created by Bradley De Boer on 11/7/24.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //This variable is the total exp counter
    var exp = 0
    
    //this function registers the click on button and increses the exp count accordingly and calls the updateExpCount() function to display the updated exp count on the ui label
    @IBAction func Main_Clicker(_ sender: Any) {
        exp += 1
        updateExpCount()
        if exp == 1000{
            view.backgroundColor = .yellow
        }
        if exp == 100000{
            view.backgroundColor = .blue
        }
        if exp == 20000{
            view.backgroundColor = .green
        }
        if exp == 500000{
            view.backgroundColor = .black
        }
        if exp == 1000000{
            view.backgroundColor = .red
        }
        if exp == 1500000{
            view.backgroundColor = .blue
        }
    }
    
    
    
    
    
    
    
    
    //Function for the button that closes the upgrade menu
    @IBAction func Close_Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
    }
    
    //upgrade menu variable
    @IBOutlet weak var Upgrade_Menu_Ui_View: UIView!
    
    //UI Button that will open the upgrade menu on click
    @IBAction func Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
    }
    
    
    
    
    
    
    
    
    
    
    //UI Label that displays the current amount of exp
    @IBOutlet weak var Exp_Count_Display: UILabel!
    
    //This function will update the text that is on the ui label whenever the button is clicked
    func updateExpCount() {
        Exp_Count_Display.text = "Exp: \(exp)"
        Exp_Count_Display.textAlignment = .center
    }
    
}
