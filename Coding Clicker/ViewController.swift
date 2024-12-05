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
        
        //updates each exp label to 0 on startup
        updateExpCount(label: Exp_Count_Display)
        updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
        
        //updates upgrade 1 cost label in menu
        updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        //updates upgrade 1 quantity label in menu
        updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: upgrade1quantity)
        
        //updates upgrade 2 cost label in menu
        updateCostLabel(label: Upgrade2Cost, price: upgrade2cost)
        //updates upgrade 2 quantity label in menu
        updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: Int(upgrade2quantity))
        
        
        
        //hides the cannot afford upgrade label
        fadeInAndOut(label: CannotAffordUpgradeLabel)
        //hides max amount of upgrade label
        fadeInAndOut(label: MaxAmountReached)
        
        
        //flip top triangles to make background for exp display
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
        if exp >= 100{
            view.backgroundColor = .yellow
            Upgrade_Menu_Ui_View.backgroundColor = .yellow
        }
        if exp >= 100000{
            view.backgroundColor = .blue
            Upgrade_Menu_Ui_View.backgroundColor = .blue
        }
        if exp >= 20000{
            view.backgroundColor = .green
            Upgrade_Menu_Ui_View.backgroundColor = .green
        }
        if exp >= 500000{
            view.backgroundColor = .black
            Upgrade_Menu_Ui_View.backgroundColor = .black
        }
        if exp >= 1000000{
            view.backgroundColor = .red
            Upgrade_Menu_Ui_View.backgroundColor = .red
        }
        if exp >= 1500000{
            view.backgroundColor = .blue
            Upgrade_Menu_Ui_View.backgroundColor = .blue
        }
    }
    
    
    
    
    
    //uiLabel for when max amount of upgrade has been reached
    @IBOutlet weak var MaxAmountReached: UILabel!
    
    //uiLabel for when the user cannot afford the upgrade
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
        updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
    }
    
    
    //first upgrade available, upgrades words per minute ie increases exp multiplier
    var upgrade1multiplier = 1.0
    var upgrade1Cost = 10.0
    var upgrade1quantity = 0
    
    //first upgrade quantity label
    @IBOutlet weak var Upgrade1Quantity: UILabel!
    
    @IBAction func Upgrade1WPMBoost(_ sender: Any) {

        //flashes the maxamountreach label on screen when user has purchased upgrade 1 10 times
        if (upgrade1quantity == 10) {
            fadeInAndOut(label: MaxAmountReached)
        }
        else if (Int(exp) >= Int(upgrade1Cost) && upgrade1quantity < 10) {
            exp -= upgrade1Cost
            upgrade1quantity += 1
                
            //updates all necessary information after purhcasing the upgrade
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateExpCount(label: Exp_Count_Display)
            updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: upgrade1quantity)
            
            multiplier += 0.25
            upgrade1multiplier *= 1.23
            
            upgrade1Cost = upgrade1Cost * upgrade1multiplier
            updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        }
        else if (Int(exp) < Int(upgrade1Cost)){
            fadeInAndOut(label: CannotAffordUpgradeLabel)
        }
    }
    
    
    //upgrade 2 (intern upgrade) member variables
    var upgrade2quantity = 0.0
    var upgrade2cost = 100.0
    var ownsUpgrade2 = false
    
   
    @IBOutlet weak var Upgrade2Cost: UILabel!
    
    @IBOutlet weak var Upgrade2Quantity: UILabel!
    
    @IBAction func HireInternsUpgrade(_ sender: Any) {
        if (upgrade2quantity == 5) {
            fadeInAndOut(label: MaxAmountReached)
        }
        else if (Int(exp) >= Int(upgrade2cost) && upgrade2quantity < 5) {
            exp -= upgrade2cost
            upgrade2quantity += 1
            ownsUpgrade2 = true
            upgrade2cost += 100
            //updates cost in menu
            updateCostLabel(label: Upgrade2Cost, price: upgrade2cost)
            
            //updates all necessary information after purhcasing the upgrade
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateExpCount(label: Exp_Count_Display)
            updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: Int(upgrade2quantity))
            
            Task {
                while ownsUpgrade2 {
                    try await Task.sleep(nanoseconds: 2_000_000_000)  // 2 seconds
                    exp += 1 * upgrade2quantity
                    updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                    updateExpCount(label: Exp_Count_Display)
                }
            }
        }
        else if (Int(exp) < Int(upgrade2cost)){
            fadeInAndOut(label: CannotAffordUpgradeLabel)
        }
    }
    
    
    
    
    
    
    
    //UI Label that displays the current amount of exp
    @IBOutlet weak var Exp_Count_Display: UILabel!
    
    //This function will update the text that is on the ui label whenever the button is clicked
    func updateExpCount(label: UILabel) {
        label.text = "\(Int(exp))"
        label.textAlignment = .center
    }
//this function functions the same just without the center alignment of the text
    func updateExpCountInUpgradeMenu(label: UILabel) {
        label.text = "Spendable Currency: \(Int(exp))"
        label.textAlignment = .left
    }
    
    //this function will update each cost label with the new associated cost for each upgrade
    func updateCostLabel (label: UILabel, price: Double) {
        label.text = "\(Int(price))"
        label.textAlignment = .center
    }
    
    //this function updates the quantity labels for upgrade 1 (wpm)
    func updateQuantityLabelUpgrade1 (label: UILabel, quantity: Int) {
        label.text = "\(quantity)/10"
        label.textAlignment = .center
    }
    //this function updates the quantity label for upgrade 2 (interns)
    func updateQuantityLabelUpgrade2 (label: UILabel, quantity: Int) {
        label.text = "\(quantity)/5"
        label.textAlignment = .center
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
