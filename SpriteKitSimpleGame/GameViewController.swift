//
//  GameViewController.swift
//  SpriteKitSimpleGame
//
//  Created by Rooksgc on 27.12.16.
//  Copyright © 2016 Антон Шестаков. All rights reserved.
//

//import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var skView: SKView!
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skView = view as! SKView
        scene = GameScene(size: view.bounds.size)
        
        scene.scaleMode = .aspectFill
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        skView = view as! SKView
        skView.presentScene(nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
}
