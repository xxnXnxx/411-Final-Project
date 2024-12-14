# Lappy Smash

## Author Information

**Author Name**: Bradley De Boer  | Ian Gabriel Vista
**Email**: bradleydeboer@csu.fullerton.edu | vistaiangabriel@csu.fullerton.edu

## Game Mechanics

- **Objective**: The goal of our game is to accumulate experience points (EXP) by clicking on the laptop icon. The player can use this EXP to purchase upgrades, each improving the player's EXP multiplier or adding passive income sources like interns.
- **Upgrades**:
  - **Code Compiler**: Increases the EXP multiplier.
  - **Hire Interns!**: Generates passive EXP over time.
  - **Algorithm Optimizer**: Increases the EXP multiplier with an algorithm-based upgrade.
  - **Stack Overflow**: Increase the EXP multiplier significantly.
- **EXP Display**: The player's EXP is displayed on the main screen and is updated as the player earns EXP.
- **Upgrade Menu**: The upgrade menu allows players to spend EXP to buy upgrades that improve the game's performance or provide passive bonuses.

## How to Run

1. Clone or download the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the app on a simulator or a connected iOS device.

## How to Play

1. Click on the laptop button to generate EXP.
2. Open the upgrade menu (bottom button) to purchase upgrades using the EXP you've earned.
3. Each upgrade improves the rate at which you generate EXP, either by increasing your multiplier or by adding passive sources of EXP ("Hire Interns!" Upgrade).
4. As you accumulate more EXP the background color will change to indicate your progress at predetermined intervals, some of which are  100, 1000, 5000, etc. If a players EXP drops below one of these intervals, from purchasing upgrades, the background color will change according to the current EXP value.

## Technical Packages

- **UIKit**: Used for building the user interface.
- **CoreData**: For persistent data storage.
- **AVFoundation**: For background music and sound effects.
- **AudioToolbox**: For playing system sounds and providing haptic feedback.

## Programming Language

- **Swift**: The game is written in Swift, utilizing modern iOS frameworks and APIs.
