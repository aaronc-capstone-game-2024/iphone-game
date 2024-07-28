//
//  MenuScene.swift
//  Physics test
//
//  Created by Aaron C on 7/16/24.
//

import SpriteKit



class MenuScene: SKScene {
    let instructionLabel = SKLabelNode(text: "Instructions")

    override func didMove(to view: SKView) {
           let background = SKSpriteNode(imageNamed: "blueSky")
           background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
           background.size = self.frame.size
           self.addChild(background)
        
        addLogo()
        addLabels()
        instructions()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "masorchi")
        logo.size = CGSize(width: (frame.width/2) * 1.5, height: (frame.height/4) * 1.5)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        logo.zPosition = 1
        addChild(logo)
    }
    
    func addLabels() {
        let playLabel = SKLabelNode(text: "Tap to Play")
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.fontColor = .black
        playLabel.fontName = "Optima-ExtraBlack"
        playLabel.zPosition = 1
        addChild(playLabel)
        
        let highscore = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
        highscore.position = CGPoint(x: frame.midX, y: frame.midY - highscore.frame.size.height*4)
        highscore.fontColor = .black
        highscore.fontName = "Optima-ExtraBlack"
        highscore.zPosition = 1
        addChild(highscore)
    }
    
    func instructions() {
        instructionLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        instructionLabel.fontColor = .black
        instructionLabel.fontName = "Optima-ExtraBlack"
        instructionLabel.zPosition = 1
        addChild(instructionLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if instructionLabel.frame.contains(touchLocation) {
                let scene = Tutorial(size: CGSize(width: self.frame.width, height: self.frame.height))
                view!.presentScene(scene)
            } else {
                let gameScene = GameScene(size: CGSize(width: self.frame.width, height: self.frame.height))
                gameScene.scaleMode = .aspectFill
                view!.presentScene(gameScene)
            }
        }
    }
}
