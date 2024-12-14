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
    // EXP Counter Variable and Mutator
    var exp = 0.0
    var multiplier = 1.0

    //first upgrade's associated variables, upgrades words per minute ie increases exp multiplier
    var upgrade1multiplier = 1.15
    var upgrade1Cost = 10.0
    var upgrade1quantity = 0

    //upgrade 2 (intern upgrade) member variables (upgrades were intially created in order but as more upgrades were added variable names become more specific to each upgrade
    var upgrade2quantity = 0.0
    var upgrade2cost = 700.0
    var ownsUpgrade2 = false

    // Algorithm upgrade variables
    var AlgoCost = 100.0
    var AlgoQuantity = 0
    
    //StackOverflow upgrade variables
    var StackOverflowCost = 2000.0
    var StackOverflowQuantity = 0
    
    // Audio player
    var AudioPlayer = AVAudioPlayer()
    
    //Properties
    @IBOutlet weak var MenuView: UIView!
    //Outlets
    @IBOutlet weak var MainButton: UIButton!
    @IBOutlet weak var expDisplay1: UIImageView!
    @IBOutlet weak var expDisplay2: UIImageView!
    //uiLabel for when max amount of upgrade has been reached
    @IBOutlet weak var MaxAmountReached: UILabel!
    //uiLabel for when the user cannot afford the upgrade
    @IBOutlet weak var CannotAffordUpgradeLabel: UILabel!
    //label that shows exp in the upgrade menu displaying how much exp you have to spend
    @IBOutlet weak var Upgrade_Menu_Exp: UILabel!
    //label that shows cost for the first upgrade
    @IBOutlet weak var Upgrade_1_Cost: UILabel!
    //first upgrade's associated labels
    @IBOutlet weak var Upgrade1Quantity: UILabel!
    @IBOutlet weak var Upgrade2Cost: UILabel!
    @IBOutlet weak var Upgrade2Quantity: UILabel!
    //Algorithm Upgrade associated labels
    @IBOutlet weak var AlgorithmCost: UILabel!
    @IBOutlet weak var AlgorithmQuantity: UILabel!
    //StackOverflow Upgrade associated labels
    @IBOutlet weak var StackOverflowCostLabel: UILabel!
    @IBOutlet weak var StackOverflowQuantityLabel: UILabel!
    //UI Label that displays the current amount of exp on the main screen ie not upgrade menu
    @IBOutlet weak var Exp_Count_Display: UILabel!
    //upgrade menu UI View variable
    @IBOutlet weak var Upgrade_Menu_Ui_View: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //updates each exp label to 0 on startup
        updateExpCount(label: Exp_Count_Display)
        updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
        
        //updates code compiler upgrade cost and quantity label in menu
        updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
        updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: Int(upgrade1quantity))
        
        //updates Hire Interns upgrade cost and quantity label on start up
        updateCostLabel(label: Upgrade2Cost, price: upgrade2cost)
        updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: Int(upgrade2quantity))
        
        //updates algoritm upgrade cost and quantity on boot up
        updateCostLabel(label: AlgorithmCost, price: AlgoCost)
        updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: Int(AlgoQuantity))
        
        //updates StackOverflow upgrade cost and quantity label on boot up
        updateCostLabel(label: StackOverflowCostLabel, price: StackOverflowCost)
        updateQuantityLabelUpgrade1(label: StackOverflowQuantityLabel, quantity: Int(StackOverflowQuantity))
        
        // Hide temporary labels
        fadeInAndOut(label: CannotAffordUpgradeLabel)
        fadeInAndOut(label: MaxAmountReached)

        // Play background music
        let musicURL = Bundle.main.url(forResource: "bg_music", withExtension: "mp3")!
            AudioPlayer = try! AVAudioPlayer(contentsOf: musicURL)
            AudioPlayer.prepareToPlay()
            AudioPlayer.numberOfLoops = -1
            AudioPlayer.play()
                
            // Register for app lifecycle notifications
            NotificationCenter.default.addObserver(self, selector: #selector(pauseMusic), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(playMusic), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    //This function registers the click on button and increases the exp count accordingly and calls the updateExpCount() function to display the updated exp count on the ui label
    @IBAction func Main_Clicker(_ sender: Any) {
        expEarnedLabel(button: MainButton)
        exp += 1 * multiplier
        updateExpCount(label: Exp_Count_Display)
        updateViewColor(exp: Int(exp))

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

    //Code Compiler Button Code (upgrade names changed over time)
    @IBAction func Upgrade1WPMBoost(_ sender: Any) {
        //checks if max quantity for the upgrade was reached, flashes max amount reached label on screen if so and updates the quantity label to 10/10
        if upgrade1quantity == 10 {
            fadeInAndOut(label: MaxAmountReached, costLabel: Upgrade_1_Cost)
        }
        //if max quantity has yet to be reached the following code subtracts the cost of the upgrade from the users total exp value and increments/updates the associated upgrade cost, quantity, and the exp multiplier accordingly
        else if Int(exp) >= Int(upgrade1Cost) && upgrade1quantity < 10 {
            exp -= upgrade1Cost
            upgrade1quantity += 1
            multiplier += 1
            upgrade1Cost *= 1.23
            
            if upgrade1quantity == 10 {
                updateCostLabel(label: Upgrade_1_Cost, price: 0.0)
                updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: 10)
            }
            else {
                //updates all necessary information after purhcasing the upgrade
                updateExpCount(label: Exp_Count_Display)
                updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                updateQuantityLabelUpgrade1(label: Upgrade1Quantity, quantity: upgrade1quantity)
                updateCostLabel(label: Upgrade_1_Cost, price: upgrade1Cost)
                updateViewColor(exp: Int(exp))
            }
        }
        //if neither of the previous if statements are meant that means that the user does not have enough exp to purchase this upgrade in which case the "CannotAffordUpgradeLabel" will flash on screen, not permitting the user to purchase the uprade and any associated benefits
        else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: Upgrade_1_Cost)
        }
    }

    @IBAction func HireInternsUpgrade(_ sender: Any) {
        //checks if max quantity for the upgrade was reached, flashes max amount reached label on screen if so and updates the quantity label to 5/5
        if upgrade2quantity == 5 {
            fadeInAndOut(label: MaxAmountReached, costLabel: Upgrade2Cost)
        }
        //if max quantity has yet to be reached the following code subtracts the cost of the upgrade from the users total exp value and increments/updates the associated upgrade cost, quantity, and the exp multiplier accordingly
        else if Int(exp) >= Int(upgrade2cost) && upgrade2quantity < 5 {
            exp -= upgrade2cost
            upgrade2quantity += 1
            ownsUpgrade2 = true
            upgrade2cost *= 1.35
            
            if upgrade2quantity == 5 {
                updateCostLabel(label: Upgrade2Cost, price: 0.0)
                updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: 5)
            }
            else {
                //updates cost in menu
                updateCostLabel(label: Upgrade2Cost, price: upgrade2cost)
                
                //updates all necessary information after purhcasing the upgrade
                updateExpCount(label: Exp_Count_Display)
                updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                updateQuantityLabelUpgrade2(label: Upgrade2Quantity, quantity: Int(upgrade2quantity))
                updateViewColor(exp: Int(exp))
            }
            
            //The following code block is designed to constantly run when the boolean "ownsUpgrade2" is set to true. When set to true the while loop begins running. The loop repeats every 2 seconds with an inbuilt sleep function. This block updates the users exp every 2 seconds with the associated upgrade quantity. (If a user has bought multiple of these upgrades they own multiple interns meaning the amount of clicks earned passivley every 2 seconds is multiplied by upgrade quantity
            Task {
                while ownsUpgrade2 {
                    try await Task.sleep(nanoseconds: 1_300_000_000) // 1.3 seconds
                    expEarnedLabel(button: MainButton, multiplier: Int(upgrade2quantity))
                    exp += 2 * upgrade2quantity
                    updateExpCount(label: Exp_Count_Display)
                    updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                }
            }
        }
        //if neither of the previous if statements are meant that means that the user does not have enough exp to purchase this upgrade in which case the "CannotAffordUpgradeLabel" will flash on screen, not permitting the user to purchase the uprade and any associated benefits
        else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: Upgrade2Cost)
        }
    }

    @IBAction func AlgorithmUpgrade(_ sender: Any) {
        //checks if max quantity for the upgrade was reached, flashes max amount reached label on screen if so and updates the quantity label to 10/10
        if AlgoQuantity == 10 {
            fadeInAndOut(label: MaxAmountReached, costLabel: AlgorithmCost)
        }
        //if max quantity has yet to be reached the following code subtracts the cost of the upgrade from the users total exp value and increments/updates the associated upgrade cost, quantity, and the exp multiplier accordingly
        else if Int(exp) >= Int(AlgoCost) && AlgoQuantity < 10 {
            exp -= AlgoCost
            AlgoQuantity += 1
            AlgoCost *= 1.25
            multiplier += 1.2
            
            if AlgoQuantity == 10 {
                updateCostLabel(label: AlgorithmCost, price: 0.0)
                updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: 10)
            }
            else {
                updateCostLabel(label: AlgorithmCost, price: AlgoCost)
                updateExpCount(label: Exp_Count_Display)
                updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                updateQuantityLabelUpgrade1(label: AlgorithmQuantity, quantity: Int(AlgoQuantity))
                updateViewColor(exp: Int(exp))
            }
        }
        //if neither of the previous if statements are meant that means that the user does not have enough exp to purchase this upgrade in which case the "CannotAffordUpgradeLabel" will flash on screen, not permitting the user to purchase the uprade and any associated benefits
        else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: AlgorithmCost)
        }
    }
    
    @IBAction func StackOverflowUpgrade(_ sender: Any) {
        //checks if max quantity for the upgrade was reached, flashes max amount reached label on screen if so and updates the quantity label to 10/10
        if StackOverflowQuantity == 10 {
            fadeInAndOut(label: MaxAmountReached, costLabel: StackOverflowCostLabel)
        }
        //if max quantity has yet to be reached the following code subtracts the cost of the upgrade from the users total exp value and increments/updates the associated upgrade cost, quantity, and the exp multiplier accordingly
        else if Int(exp) >= Int(StackOverflowCost) && StackOverflowQuantity < 10 {
            exp -= StackOverflowCost
            StackOverflowQuantity += 1
            StackOverflowCost *= 1.43
            multiplier += 1.7
            
            if StackOverflowQuantity == 10 {
                updateCostLabel(label: StackOverflowCostLabel, price: 0.0)
                updateQuantityLabelUpgrade1(label: StackOverflowQuantityLabel, quantity: 10)
            }
            else {
                updateCostLabel(label: StackOverflowCostLabel, price: StackOverflowCost)
                updateExpCount(label: Exp_Count_Display)
                updateExpCountInUpgradeMenu(label: Upgrade_Menu_Exp)
                updateQuantityLabelUpgrade1(label: StackOverflowQuantityLabel, quantity: Int(StackOverflowQuantity))
                updateViewColor(exp: Int(exp))
            }
        }
        //if neither of the previous if statements are meant that means that the user does not have enough exp to purchase this upgrade in which case the "CannotAffordUpgradeLabel" will flash on screen, not permitting the user to purchase the uprade and any associated benefits
        else {
            fadeInAndOut(label: CannotAffordUpgradeLabel, costLabel: StackOverflowCostLabel)
        }
    }
    
    //Background Music Settings
    deinit {
            NotificationCenter.default.removeObserver(self)
    }
        
    // Pause music when app is inactive
    @objc func pauseMusic() {
        if AudioPlayer.isPlaying {
            AudioPlayer.pause()
        }
    }
        
    // Resume music when app is active again
    @objc func playMusic() {
        if !AudioPlayer.isPlaying {
            AudioPlayer.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    //very similar function but with a faster fade in fade out time for the "+1" that apperas around the button on tap
    func fadeInAndOutPlusOneLabel (label: UILabel, costLabel: UILabel? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            label.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: {
                label.alpha = 0.0
            }, completion: nil)
        }
    }
    
    //This function produces a "+1" label that fades in and out around the main button whenever exp is earned
    func expEarnedLabel (button : UIButton, multiplier : Int? = 1) {
        let innerRadius : CGFloat = 120.0
        let outerRadius : CGFloat = 130.0
        
        let buttonCenter = button.center
        
        //calculate a random distance and angle to produce the label at
        let angle = CGFloat.random(in: 0...(2 * .pi))
        let distance = CGFloat.random(in: innerRadius...outerRadius)
        //calculate random postition around the button
        let randomX = buttonCenter.x + distance * cos(angle)
        let randomY = buttonCenter.y + distance * sin(angle)
        
        // Create the "+1" label
        let plusOneLabel = UILabel()
        plusOneLabel.text = "+\(multiplier ?? 1)"
        plusOneLabel.textColor = .black
        plusOneLabel.font = UIFont.boldSystemFont(ofSize: 28)
        plusOneLabel.sizeToFit()
        plusOneLabel.center = CGPoint(x: randomX, y: randomY)
        plusOneLabel.alpha = 0 // Start invisible
    
        view.insertSubview(plusOneLabel, at: 0)
        
        fadeInAndOutPlusOneLabel(label: plusOneLabel)
    }
    
    //Function for changing of background color at predetermined milestones
    func updateViewColor(exp: Int) {
            if (exp < 100) {
                view.backgroundColor = .white
            }
            else if (exp < 1000 && exp > 100) {
                view.backgroundColor = .systemTeal
            }
            else if (exp < 10000 && exp > 1000) {
                view.backgroundColor = .systemCyan
            }
            else if (exp < 50000 && exp > 10000) {
                view.backgroundColor = .systemOrange
            }
            else if (exp < 100000 && exp > 50000) {
                view.backgroundColor = .systemYellow
            }
            else if (exp < 250000 && exp > 100000) {
                view.backgroundColor = .systemGreen
            }
            else if (exp < 500000 && exp > 250000) {
                view.backgroundColor = .systemBlue
            }
            else if (exp < 1000000 && exp > 500000) {
                view.backgroundColor = .systemMint
            }
            else if (exp < 2000000 && exp > 1000000) {
                view.backgroundColor = .systemPink
            }
            else if (exp >= 2000000) {
                view.backgroundColor = .systemBrown
            }
        }
    }
