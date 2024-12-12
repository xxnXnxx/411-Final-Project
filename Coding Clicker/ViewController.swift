//  ViewController.swift
//  Coding Clicker
//
//  Created by Bradley De Boer on 11/7/24.
//

import SwiftUI
import UIKit
import AVFoundation
import AudioToolbox

class ViewController: UIViewController {
    //Properties
    // EXP Counter Variables
    var exp = 0.0
    var multiplier = 1.0

    //first upgrade available, upgrades words per minute ie increases exp multiplier
    var upgrade1multiplier = 1.15
    var upgrade1Cost = 10.0
    var upgrade1quantity = 0

    //upgrade 2 (intern upgrade) member variables
    var upgrade2quantity = 0.0
    var upgrade2cost = 1000.0
    var ownsUpgrade2 = false

    // Algorithm upgrade properties
    var AlgoCost = 100.0
    var AlgoQuantity = 0
    
    // Audio player
    var AudioPlayer = AVAudioPlayer()
    
    // Outlets
    @IBOutlet weak var expDisplay1: UIImageView!
    @IBOutlet weak var expDisplay2: UIImageView!
    //uiLabel for when max amount of upgrade has been reached
    @IBOutlet weak var MaxAmountReached: UILabel!
    //uiLabel for when the user cannot afford the upgrade
    @IBOutlet weak var CannotAffordUpgradeLabel: UILabel!
    //label that shows exp in the upgrade menu
    @IBOutlet weak var Upgrade_Menu_Exp: UILabel!
    //label that shows cost for the first upgrade
    @IBOutlet weak var Upgrade_1_Cost: UILabel!
    //first upgrade quantity label/
    @IBOutlet weak var Upgrade1Quantity: UILabel!
    @IBOutlet weak var Upgrade2Cost: UILabel!
    @IBOutlet weak var Upgrade2Quantity: UILabel!
    @IBOutlet weak var AlgorithmCost: UILabel!
    @IBOutlet weak var AlgorithmQuantity: UILabel!
    //UI Label that displays the current amount of exp
    @IBOutlet weak var Exp_Count_Display: UILabel!
    //upgrade menu variable
    @IBOutlet weak var Upgrade_Menu_Ui_View: UIView!
    //uiLabel for when the user cannot afford the upgrade

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        updateCostLabel(label: AlgorithmCost, price: AlgoCost)
        updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: Int(AlgoQuantity))
        
        // Hide temporary labels
        fadeInAndOut(label: CannotAffordUpgradeLabel)
        fadeInAndOut(label: MaxAmountReached)

        // Play background music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "bg_music", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = -1
        AudioPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function registers the click on button and increases the exp count accordingly and calls the updateExpCount() function to display the updated exp count on the ui label
    @IBAction func Main_Clicker(_ sender: Any) {
        exp += 1 * multiplier
        updateExpCount(label: Exp_Count_Display)

        // Update background color based on exp milestones
        switch exp {
        case 10:
            view.backgroundColor = .red
        case 1000...9999:
            view.backgroundColor = .systemRed
        case 10000...49999:
            view.backgroundColor = .systemOrange
        case 50000...999999:
            view.backgroundColor = .systemYellow
        case 100000...249999:
            view.backgroundColor = .systemGreen
        case 250000...499999:
            view.backgroundColor = .systemBlue
        case 500000...999999:
            view.backgroundColor = .systemIndigo
        case 1000000...1999999:
            view.backgroundColor = .systemPurple
        case 2000000...:
            view.backgroundColor = .clear
        default:
            view.backgroundColor = .white
            break
        }

        // Play sound and vibration
        AudioServicesPlaySystemSound(SystemSoundID(1333)) // Telegraph sound
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate)) // Vibrate
    }
    
    //Function for the button that closes the upgrade menu
    @IBAction func Close_Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
        Upgrade_Menu_Exp.isHidden.toggle()
    }
    
    //UI Button that will open the upgrade menu on click
    @IBAction func Upgrade_Menu_Button(_ sender: Any) {
        Upgrade_Menu_Ui_View.isHidden.toggle()
        Upgrade_Menu_Exp.isHidden.toggle()
        updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
    }

    @IBAction func Upgrade1WPMBoost(_ sender: Any) {
        //flashes the maxamountreach label on screen when user has purchased upgrade 1 10 times
        if upgrade1quantity == 9 {
            fadeInAndOut(label: MaxAmountReached, costLabel: Upgrade_1_Cost)
            updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: 10)
        } else if Int(exp) >= Int(upgrade1Cost) && upgrade1quantity < 10 {
            exp -= upgrade1Cost
            upgrade1quantity += 1
            multiplier += 1
            upgrade1Cost *= 1.15
            
            //updates all necessary information after purhcasing the upgrade
            updateExpCount(label: Exp_Count_Display)
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: upgrade1quantity)
            updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        } else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: Upgrade_1_Cost)
        }
    }

    @IBAction func HireInternsUpgrade(_ sender: Any) {
        if upgrade2quantity == 4 {
            fadeInAndOut(label: MaxAmountReached, costLabel: Upgrade2Cost)
            updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: 5)
        } else if Int(exp) >= Int(upgrade2cost) && upgrade2quantity < 5 {
            exp -= upgrade2cost
            upgrade2quantity += 1
            ownsUpgrade2 = true
            upgrade2cost *= 1.35
            
            //updates cost in menu
            updateCostLabel(label: Upgrade2Cost, price: upgrade2cost)
            
            //updates all necessary information after purhcasing the upgrade
            updateExpCount(label: Exp_Count_Display)
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: Int(upgrade2quantity))

            Task {
                while ownsUpgrade2 {
                    try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                    exp += 2 * upgrade2quantity
                    updateExpCount(label: Exp_Count_Display)
                    updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                }
            }
        } else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: Upgrade2Cost)
        }
    }

    @IBAction func AlgorithmUpgrade(_ sender: Any) {
        if AlgoQuantity == 9 {
            fadeInAndOut(label: MaxAmountReached, costLabel: AlgorithmCost)
            updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: 10)
        } else if Int(exp) >= Int(AlgoCost) && AlgoQuantity < 10 {
            exp -= AlgoCost
            AlgoQuantity += 1
            AlgoCost *= 1.25
            multiplier += 1.2

            updateCostLabel(label: AlgorithmCost, price: AlgoCost)
            updateExpCount(label: Exp_Count_Display)
            updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
            updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: Int(AlgoQuantity))
        } else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: AlgorithmCost)
        }
    }

    // Helper Methods
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
    func updateCostLabel(label: UILabel, price: Double) {
        label.text = price == 0.0 ? "--" : "\(Int(price))"
        label.textAlignment = .center
    }
    
    //this function updates the quantity labels for upgrade 1 (wpm)
    func updateQuantityLabelUpgrade1(label: UILabel, quantity: Int) {
        label.text = "\(quantity)/10"
        label.textAlignment = .center
    }
    
    //this function updates the quantity label for upgrade 2 (interns)
    func updateQuantityLabelUpgrade2(label: UILabel, quantity: Int) {
        label.text = "\(quantity)/5"
        label.textAlignment = .center
    }
    
    //allows a UILabel to fade in and out of the scene
    func fadeInAndOut(label: UILabel, costLabel: UILabel? = nil) {
        if label == MaxAmountReached, let costLabel = costLabel {
            updateCostLabel(label: costLabel, price: 0.0)
        }

        UIView.animate(withDuration: 1.0, animations: {
            label.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 1.0, delay: 1.0, options: [], animations: {
                label.alpha = 0.0
            }, completion: nil)
        }
    }
}
