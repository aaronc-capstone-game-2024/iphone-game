//
//  MenuScene.swift
//  Physics test
//
//  Created by Aaron C on 7/16/24.
//

import SpriteKit



class MenuScene: SKScene {
    let playLabel = SKLabelNode(text: "Tap to Play")
    let instructionLabel = SKLabelNode(text: "Instructions")
    var character = SKSpriteNode(imageNamed: GameManager.shared.skins[GameManager.shared.currSkin])
    var background = SKSpriteNode(imageNamed: GameManager.shared.backgrounds[GameManager.shared.currBack])
    let rightArrow = SKSpriteNode(imageNamed: "next1")
    let leftArrow = SKSpriteNode(imageNamed: "next1")
    let upArrow = SKSpriteNode(imageNamed: "next1")
    let downArrow = SKSpriteNode(imageNamed: "next1")

    override func didMove(to view: SKView) {
        // background
        background.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        background.size = self.frame.size
        self.addChild(background)
        
        // add character
        character.position = CGPoint(x: frame.midX, y: frame.midY)
        character.zPosition = 1
        character.size = CGSize(width: 90, height: 100)
        addChild(character)
        
        //animate character
        let animation = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 1)
        let sequence = SKAction.sequence([animation, animation.reversed()])
        character.run(SKAction.repeatForever(sequence))
        
        // add arrows
        rightArrow.position = CGPoint(x: character.position.x + 100, y: frame.midY)
        rightArrow.size = CGSize(width: 35, height: 40)
        rightArrow.zPosition = 1
        addChild(rightArrow)
        
        leftArrow.position = CGPoint(x: character.position.x - 100, y: frame.midY)
        leftArrow.size = CGSize(width: 35, height: 40)
        leftArrow.zPosition = 1
        leftArrow.zRotation = .pi
        addChild(leftArrow)
        
        upArrow.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        upArrow.size = CGSize(width: 35, height: 40)
        upArrow.zPosition = 1
        upArrow.zRotation = .pi / 2
        addChild(upArrow)
        
        downArrow.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        downArrow.size = CGSize(width: 35, height: 40)
        downArrow.zPosition = 1
        downArrow.zRotation = .pi / -2
        addChild(downArrow)
        
        addLogo()
        addLabels()
        instructions()
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "masorchi")
        logo.size = CGSize(width: (frame.width/2) * 1.5, height: (frame.height/4) * 1.5)
        logo.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        logo.zPosition = 1
        addChild(logo)
    }
    
    func addLabels() {
        playLabel.position = CGPoint(x: frame.midX, y: frame.minY + 220)
        playLabel.fontColor = .black
        playLabel.fontName = "Optima-ExtraBlack"
        playLabel.zPosition = 1
        addChild(playLabel)
        
        let highscore = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
        highscore.position = CGPoint(x: frame.midX, y: frame.minY + 160)
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
    
    override func update(_ currentTime: TimeInterval) {
        updateSkin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if rightArrow.frame.contains(touchLocation) {
                GameManager.shared.currSkin += 1
                if GameManager.shared.currSkin == GameManager.shared.skins.count {
                    GameManager.shared.currSkin = 0
                }
                updateSkin()
            }
            
            if upArrow.frame.contains(touchLocation) {
                GameManager.shared.currBack += 1
                if GameManager.shared.currBack == GameManager.shared.backgrounds.count {
                    GameManager.shared.currBack = 0
                }
                updateBack()
            }
            
            if leftArrow.frame.contains(touchLocation) {
                GameManager.shared.currSkin -= 1
                if GameManager.shared.currSkin == -1 {
                    GameManager.shared.currSkin = GameManager.shared.skins.count - 1
                }
                updateSkin()
            }
            
            if downArrow.frame.contains(touchLocation) {
                GameManager.shared.currBack -= 1
                if GameManager.shared.currBack == -1 {
                    GameManager.shared.currBack = GameManager.shared.backgrounds.count - 1
                }
                updateBack()
            }
            
            if instructionLabel.frame.contains(touchLocation) {
                let scene = Tutorial(size: CGSize(width: self.frame.width, height: self.frame.height))
                view!.presentScene(scene)
            }
            
            if playLabel.frame.contains(touchLocation) {
                let gameScene = GameScene(size: CGSize(width: self.frame.width, height: self.frame.height))
                gameScene.scaleMode = .aspectFill
                view!.presentScene(gameScene)
            }
        }
    }
    
    func updateSkin() {
        let newTexture = SKTexture(imageNamed: GameManager.shared.skins[GameManager.shared.currSkin])
        character.texture = newTexture
    }
    
    func updateBack() {
        let newTexture = SKTexture(imageNamed: GameManager.shared.backgrounds[GameManager.shared.currBack])
        background.texture = newTexture
    }
}
