//
//  ViewController.swift
//  Coding Clicker
//
//  Created by Bradley De Boer on 11/7/24.
//
import SwiftUI
import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        fadeInAndOut(label: CannotAffordUpgradeLabel)
        
        expDisplay1.transform = CGAffineTransform(scaleX: 1, y: -1)
        expDisplay2.transform = CGAffineTransform(scaleX:1, y: -1)
    }
    
    @IBOutlet weak var expDisplay1: UIImageView!
    
    @IBOutlet weak var expDisplay2: UIImageView!
    //This variable is the total exp counter
    var exp = 0.0
    var multiplier = 1.0
    
    //this function registers the click on button and increases the exp count accordingly and calls the updateExpCount() function to display the updated exp count on the ui label
    @IBAction func Main_Clicker(_ sender: Any) {
        exp += 1 * multiplier
        updateExpCount(label: Exp_Count_Display)
        
        //if chain will change the background color at certain intervals of exp
        if exp == 10{
            view.backgroundColor = .yellow
            Upgrade_Menu_Ui_View.backgroundColor = .yellow
        }
        if exp == 100000{
            view.backgroundColor = .blue
            Upgrade_Menu_Ui_View.backgroundColor = .blue
        }
        if exp == 20000{
            view.backgroundColor = .green
            Upgrade_Menu_Ui_View.backgroundColor = .green
        }
        if exp == 500000{
            view.backgroundColor = .black
            Upgrade_Menu_Ui_View.backgroundColor = .black
        }
        if exp == 1000000{
            view.backgroundColor = .red
            Upgrade_Menu_Ui_View.backgroundColor = .red
        }
        if exp == 1500000{
            view.backgroundColor = .blue
            Upgrade_Menu_Ui_View.backgroundColor = .blue
        }
    }
    
    
    
    
    
    
    
    
    @IBOutlet weak var CannotAffordUpgradeLabel: UILabel!
    
    
    //Function for the button that closes the upgrade menu
    @IBAction func Close_Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
        Upgrade_Menu_Exp.isHidden.toggle()
    }
    
    //label that shows exp in the upgrade menu
    @IBOutlet weak var Upgrade_Menu_Exp: UILabel!
    
    //label that shows cost for the first upgrade
    @IBOutlet weak var Upgrade_1_Cost: UILabel!
    
    //upgrade menu variable
    @IBOutlet weak var Upgrade_Menu_Ui_View: UIView!
    
    
    //UI Button that will open the upgrade menu on click
    @IBAction func Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
        Upgrade_Menu_Exp.isHidden.toggle()
//        CannotAffordUpgradeLabel.isHidden.toggle()
        updateExpCount(label: Upgrade_Menu_Exp)
    }
    
    
    //first upgrade available, upgrades words per minute ie increases exp multiplier
    var upgrade1multiplier = 1.0
    var upgrade1Cost = 10.0
    
    @IBAction func Upgrade1WPMBoost(_ sender: Any) {
//        upgrade1Cost = upgrade1Cost * upgrade1multiplier
        if (Int(exp) >= Int(upgrade1Cost)) {
            exp -= upgrade1Cost
            
            //updates all necessary information after purhcasing the upgrade
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateExpCount(label: Exp_Count_Display)
            
            multiplier += 0.25
            upgrade1multiplier *= 1.23
            
            upgrade1Cost = upgrade1Cost * upgrade1multiplier
            updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        }
        else if (Int(exp) < Int(upgrade1Cost)){
            fadeInAndOut(label: CannotAffordUpgradeLabel)
        }
    }
    
    
    
    
    
    
    
    
    //UI Label that displays the current amount of exp
    @IBOutlet weak var Exp_Count_Display: UILabel!
    
    //This function will update the text that is on the ui label whenever the button is clicked
    func updateExpCount(label: UILabel) {
        label.text = "Taps: \(Int(exp))"
        label.textAlignment = .center
    }
    //this function functions the same just without the center alignment of the text
    func updateExpCountInUpgradeMenu(label: UILabel) {
        label.text = "Taps: \(Int(exp))"
    }
    
    //this function will update each cost label with the new associated cost for each upgrade
    func updateCostLabel (label: UILabel, price: Double) {
        label.text = "\(Int(price))"
    }

    //allows a UILabel to fade in and out of the scene
    func fadeInAndOut(label: UILabel) {
            // Fade in
            UIView.animate(withDuration: 1.0, animations: {
                label.alpha = 1.0 // Fully visible
            }) { _ in
                // Fade out after a delay
                UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                    label.alpha = 0.0 // Fully transparent
                }, completion: nil)
            }
        }

}
