//
//  GameOverScene.swift
//  SpriteKitSimpleGame
//
//  Created by Rooksgc on 28.12.16.
//  Copyright © 2016 Антон Шестаков. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var win = false
    
    init(size: CGSize, win: Bool) {
        super.init(size: size)
        self.win = win
    }
    
    deinit {
        removeAllActions()
        removeAllChildren()
        print("GameOverScene is free")
    }
    
    override func didMove(to view: SKView) {
        configureScene()
        setMessages()
    }
    
    func configureScene() {
        let background = win ? SKSpriteNode(imageNamed: "win") : SKSpriteNode(imageNamed: "gameover")
        background.size = self.frame.size
        background.zPosition = -1
        background.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        addChild(background)
    }
    
    func setNewWeapon() {
        let newWeapon = SKLabelNode(fontNamed: "Cochin")
        newWeapon.text = "New weapon"
        newWeapon.fontSize = 30
        newWeapon.fontColor = SKColor.white
        newWeapon.position = CGPoint(x: size.width/2, y: size.height/2 + 140)
        addChild(newWeapon)
        
        let weaponName = SKLabelNode(fontNamed: "Cochin")
        
        switch GameScene.difficalty {
        case 1:
            weaponName.text = "Wand of Felicity"
        case 2:
            weaponName.text = "The eye of the damned"
        case 3:
            weaponName.text = "Skull of the Sector Chief"
        case 4:
            weaponName.text = "Staff of Doom"
        default:
            weaponName.text = ""
        }
        
        weaponName.fontSize = 30
        weaponName.fontColor = SKColor.white
        weaponName.position = CGPoint(x: size.width/2, y: size.height/2 + 110)
        addChild(weaponName)
        
        let weapon = SKSpriteNode(imageNamed: "weapon\(GameScene.difficalty)")
        weapon.size.width = 60
        weapon.size.height = 142
        weapon.zPosition = 2
        weapon.position = CGPoint(x: size.width/2, y: size.height/2 + 25)
        addChild(weapon)
    }
    
    func setMessages() {
        var message = win ? "Enemies have not passed!" : "Trolling level exceeded!"
        var retryMessage = win ? "Tap on the screen to start" : "Try again!"
        var playAgainMessage = win ? "level \(GameScene.difficalty + 2)" : "Tap on the screen to try again"
        
        if win {
            if GameScene.difficalty < 4 {
                GameScene.difficalty += 1
                setNewWeapon()
            } else {
                let gendalf = SKSpriteNode(imageNamed: "gendalfWins")
                gendalf.size.width = 245
                gendalf.size.height = 224
                gendalf.zPosition = 2
                gendalf.position = CGPoint(x: size.width/2, y: size.height/2 + 60)
                addChild(gendalf)
                
                message = "Great job!"
                retryMessage = "All levels complete"
                playAgainMessage = "You can start the game again"
                GameScene.difficalty = 0
            }
        }
        
        let messageLabel = SKLabelNode(fontNamed: "Cochin")
        messageLabel.text = message
        messageLabel.fontSize = 30
        messageLabel.fontColor = SKColor.white
        messageLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 80)
        addChild(messageLabel)
        
        let retryMessageLabel = SKLabelNode(fontNamed: "Cochin")
        retryMessageLabel.text = retryMessage
        retryMessageLabel.fontSize = 30
        retryMessageLabel.fontColor = SKColor.white
        retryMessageLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 110)
        addChild(retryMessageLabel)
        
        let playAgainMessageLabel = SKLabelNode(fontNamed: "Cochin")
        playAgainMessageLabel.text = playAgainMessage
        playAgainMessageLabel.fontSize = 30
        playAgainMessageLabel.fontColor = SKColor.white
        playAgainMessageLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 140)
        addChild(playAgainMessageLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // retry
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let scene = GameScene(size: size)
        
        if let view = self.view {
            scene.removeAllChildren()
            view.presentScene(scene, transition:reveal)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
