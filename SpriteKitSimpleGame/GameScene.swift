//
//  GameScene.swift
//  Gendalf against all
//
//  Created by Rooksgc on 27.12.16.
//  Copyright © 2016 Rooksgc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    static var difficalty = 0
    static var monstersAppDelay = 1.1
    
    let player = SKSpriteNode(imageNamed: "player0")
    let background = SKSpriteNode(imageNamed: "bg" + String(describing: random(min: 0, max: 2)) )
    var weapon = SKSpriteNode(imageNamed: "weapon\(difficalty)")
    
    let hitsLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    var hitsCount = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    var monstersDestroyed = 0
    let destroyMonstersToWin = 14
    var monstersMissing = 0
    let monstersMissingLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    let monstersMissingCountLabel = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
    
    let playBang = SKAction.playSoundFileNamed("bang.mp3", waitForCompletion: false)
    let playShot = SKAction.playSoundFileNamed("shot.mp3", waitForCompletion: false)
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let All       : UInt32 = UInt32.max
        static let Monster   : UInt32 = 0x1 << 1
        static let Projectile: UInt32 = 0x1 << 2
    }
    
    deinit {
        removeAllActions()
        removeAllChildren()
        print("GameScene is free")
    }
    
    override func didMove(to view: SKView) {
        configureScene()
        configurePhysics()
        beginMonstersAttack()
    }
    
    func configureScene() {
        configureMonstersAppearDelay()
        
        background.size = self.frame.size
        background.zPosition = -1
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        addChild(background)
        
        hitsLabel.text = "Hits:"
        hitsLabel.fontSize = 22
        hitsLabel.fontColor = SKColor.white
        hitsLabel.position = CGPoint(x: 80, y: size.height - 35)
        addChild(hitsLabel)
        
        hitsCount.color = SKColor.green
        hitsCount.text = "0"
        hitsCount.fontSize = 22
        hitsCount.position = CGPoint(x: 145, y: size.height - 35)
        addChild(hitsCount)
        
        monstersMissingLabel.text = "Miss:"
        monstersMissingLabel.fontSize = 22
        monstersMissingLabel.fontColor = SKColor.white
        monstersMissingLabel.position = CGPoint(x: 77, y: size.height - 60)
        addChild(monstersMissingLabel)
        
        monstersMissingCountLabel.color = SKColor.green
        monstersMissingCountLabel.text = "0"
        monstersMissingCountLabel.fontSize = 22
        monstersMissingCountLabel.position = CGPoint(x: 145, y: size.height - 60)
        addChild(monstersMissingCountLabel)
        
        player.size.width = 200
        player.size.height = 204
        player.zPosition = 1
        player.position = CGPoint(x: player.size.width/2, y: player.size.height/2)
        addChild(player)
        
        weapon.size.width = 60
        weapon.size.height = 142
        weapon.zPosition = 2
        weapon.position = CGPoint(x: player.size.width, y: player.size.height/2 - 30)
        addChild(weapon)
    }
    
    func configureMonstersAppearDelay() {
        switch GameScene.difficalty {
            case 1:
                GameScene.monstersAppDelay = 1.1
            case 2:
                GameScene.monstersAppDelay = 0.9
            case 3:
                GameScene.monstersAppDelay = 0.7
            case 4:
                GameScene.monstersAppDelay = 0.6
            case 5:
                GameScene.monstersAppDelay = 0.5
            default:
                GameScene.monstersAppDelay = 1.5
        }
    }
    
    func configurePhysics() {
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
    }
    
    func beginMonstersAttack() {
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addMonster),
                SKAction.wait(forDuration: GameScene.monstersAppDelay)
                ])
        ))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        
        let bullet = SKSpriteNode(imageNamed: "bullet\(GameScene.difficalty)")
        bullet.position = weapon.position + CGPoint(x: 15, y: 40)
        
        // determine offset of location to projectile
        let offset = touchLocation - bullet.position
        
        // shooting down or backwards fails
        if (offset.x < 0) { return }
        
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: bullet.size.width/2)
        bullet.physicsBody?.isDynamic = true
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
        bullet.physicsBody?.collisionBitMask = PhysicsCategory.None
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        
        // get the direction of where to shoot
        let direction = offset.normalized()
        let shootAmount = direction * 1000
        let realDest = shootAmount + bullet.position
        
        let move = SKAction.move(to: realDest, duration: 3.0)
        let wait = SKAction.wait(forDuration: 0.5)
        let done = SKAction.removeFromParent()
        
        if action(forKey: "shot") == nil {
            run(wait, withKey: "shot")
            addChild(bullet)
            bullet.run(SKAction.sequence([move, done]), withKey: "shot")
            
            self.run(playShot)
        }
    }
    
    func changeWeapon() {
        self.weapon.texture = SKTexture(imageNamed: "weapon\(GameScene.difficalty)")
    }
    
    func addMonster() {
        let randomInt = arc4random_uniform(11).toUIntMax()
        let monster = SKSpriteNode(imageNamed: "m" + String(randomInt) )
        let amplitude = random(min: 20, max: 80)
        let actualY = random(min: monster.size.height/2 + amplitude, max: size.height - monster.size.height/2 - amplitude)

        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
      
        addChild(monster)
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(3.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        
        // loss condition
        let loseAction = SKAction.run() {
            self.monstersMissing += 1
            self.monstersMissingCountLabel.text = String(self.monstersMissing)
            
            if self.monstersMissing > 2 {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameOverScene = GameOverScene(size: self.size, win: false)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
        }
        
        let actionMoveDone = SKAction.removeFromParent()
        
        let oscillate = SKAction.oscillation(amplitude: amplitude, timePeriod: 1.5, midPoint: monster.position)
        
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        monster.run(SKAction.repeatForever(oscillate))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // bitmask compare
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            if (firstBody.node != nil && secondBody.node != nil) {
                bulletDidCollideWithMonster(bullet: firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
            }
        }
    }
    
    func bulletDidCollideWithMonster(bullet: SKSpriteNode, monster: SKSpriteNode) {
        monstersDestroyed += 1
        
        hitsCount.text = String(monstersDestroyed)
        
        // сondition of victory
        if (monstersDestroyed > destroyMonstersToWin) {
            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: self.size, win: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
        let bang = SKSpriteNode(imageNamed: "bang\(GameScene.difficalty)")
        
        self.run(playBang)
        
        run(
            SKAction.sequence([
                SKAction.run {
                    bang.position = monster.position + CGPoint(x: monster.size.height, y: 0)
                    bang.size.width = 60
                    bang.size.height = 60
                    bang.zPosition = 2
                    self.addChild(bang)
                },
                SKAction.wait(forDuration: 0.1),
                SKAction.run {
                    bang.removeFromParent()
                }
            ])
        )
        
        bullet.removeFromParent()
        monster.removeFromParent()
    }
    
}
