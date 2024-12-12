//
//  GameScene.swift
//  Coding Clicker
//
//  Created by Ian Gabriel on 12/11/24.
//

import SpriteKit

class GameScene: SKScene {
    
    func buttonEffect() {
        let logoEffect = SKSpriteNode(imageNamed: "apple")
        logoEffect.setScale(1)
        logoEffect.position = CGPoint(x: self.size.width / 2, y: self.size.height * 0.2)
        logoEffect.zPosition = 1
        self.addChild(logoEffect)
        
        let moveLogoEff = SKAction.moveTo(y: self.size.height + logoEffect.size.height, duration: 1)
        let deleteEffect = SKAction.removeFromParent()
        let logoEffectSequence = SKAction.sequence([moveLogoEff, deleteEffect])
        logoEffect.run(logoEffectSequence)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonEffect()
    }
}
