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
    var character = SKSpriteNode(imageNamed: GameManager.shared.skins[UserDefaults.standard.integer(forKey: "skin")])
    let highscore = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "highscore"))")
    var background = SKSpriteNode(imageNamed: GameManager.shared.backgrounds[UserDefaults.standard.integer(forKey: "background")])
    lazy var playLabelBackground = labelBackground(for: playLabel, color: .white)
    lazy var highscoreBackground = labelBackground(for: highscore, color: .white)
    lazy var instructionLabelBackground = labelBackground(for: instructionLabel, color: .white)
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
        
        //animate arrows
        let leftArrowanimation = SKAction.move(by: CGVector(dx: 10, dy: 0), duration: 1)
        let leftArrowsequence = SKAction.sequence([leftArrowanimation, leftArrowanimation.reversed()])
        leftArrow.run(SKAction.repeatForever(leftArrowsequence))
        
        let rightArrowanimation = SKAction.move(by: CGVector(dx: -10, dy: 0), duration: 1)
        let rightArrowsequence = SKAction.sequence([rightArrowanimation, rightArrowanimation.reversed()])
        rightArrow.run(SKAction.repeatForever(rightArrowsequence))
        
        let upArrowanimation = SKAction.move(by: CGVector(dx: 0, dy: -10), duration: 1)
        let upArrowsequence = SKAction.sequence([upArrowanimation, upArrowanimation.reversed()])
        upArrow.run(SKAction.repeatForever(upArrowsequence))
        
        let downArrowanimation = SKAction.move(by: CGVector(dx: 0, dy: 10), duration: 1)
        let downArrowsequence = SKAction.sequence([downArrowanimation, downArrowanimation.reversed()])
        downArrow.run(SKAction.repeatForever(downArrowsequence))
        
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
        
        upArrow.position = CGPoint(x: frame.midX, y: frame.midY + 110)
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
    }
    
    func labelBackground(for label: SKLabelNode, color: UIColor) -> SKShapeNode {
        let padding: CGFloat = 10
        let background = SKShapeNode(rectOf: CGSize(width: label.frame.width + padding * 2, height: label.frame.height + padding), cornerRadius: 10)
        background.fillColor = color
        background.strokeColor = .clear
        background.position = CGPoint(x: label.position.x, y: label.position.y + padding)
        background.zPosition = 2
        return background
    }
    
    func addLogo() {
        let logo = SKSpriteNode(imageNamed: "masorchi")
        logo.size = CGSize(width: (frame.width/2) * 1.5, height: (frame.height/4) * 1.5)
        logo.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        logo.zPosition = 1
        addChild(logo)
    }
    
    func addLabels() {
        // Play label
        playLabel.position = CGPoint(x: frame.midX, y: frame.minY + 220)
        playLabel.fontColor = .black
        playLabel.fontName = "Optima-ExtraBlack"
        playLabel.zPosition = 2
        
        addChild(playLabelBackground)
        addChild(playLabel)

        // Highscore label
        highscore.position = CGPoint(x: frame.midX, y: frame.minY + 160)
        highscore.fontColor = .black
        highscore.fontName = "Optima-ExtraBlack"
        highscore.zPosition = 2
        
        addChild(highscoreBackground)
        addChild(highscore)

        // Instruction label
        instructionLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        instructionLabel.fontColor = .black
        instructionLabel.fontName = "Optima-ExtraBlack"
        instructionLabel.zPosition = 2
        
        addChild(instructionLabelBackground)
        addChild(instructionLabel)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if GameManager.shared.currBack != 0 {
            playLabel.fontColor = .white
            highscore.fontColor = .white
            instructionLabel.fontColor = .white
            playLabelBackground.fillColor = .black
            highscoreBackground.fillColor = .black
            instructionLabelBackground.fillColor = .black
        } else {
            playLabel.fontColor = .black
            highscore.fontColor = .black
            instructionLabel.fontColor = .black
            playLabelBackground.fillColor = .white
            highscoreBackground.fillColor = .white
            instructionLabelBackground.fillColor = .white
        }
        updateSkin()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if rightArrow.frame.contains(touchLocation) {
                GameManager.shared.currSkin = (GameManager.shared.currSkin + 1) % GameManager.shared.skins.count
                updateSkin()
                let playSound = SKAction.playSoundFileNamed("whoosh", waitForCompletion: false)
                self.run(playSound)
            }
            
            if upArrow.frame.contains(touchLocation) {
                GameManager.shared.currBack = (GameManager.shared.currBack + 1) % GameManager.shared.backgrounds.count
                updateBack()
                let playSound = SKAction.playSoundFileNamed("whoosh", waitForCompletion: false)
                self.run(playSound)
            }
            
            if leftArrow.frame.contains(touchLocation) {
                GameManager.shared.currSkin = (GameManager.shared.currSkin - 1 + GameManager.shared.skins.count) % GameManager.shared.skins.count
                updateSkin()
                let playSound = SKAction.playSoundFileNamed("whoosh", waitForCompletion: false)
                self.run(playSound)
            }
            
            if downArrow.frame.contains(touchLocation) {
                GameManager.shared.currBack = (GameManager.shared.currBack - 1) % GameManager.shared.backgrounds.count
                updateBack()
                let playSound = SKAction.playSoundFileNamed("whoosh", waitForCompletion: false)
                self.run(playSound)
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
        character.texture = SKTexture(imageNamed: GameManager.shared.skins[GameManager.shared.currSkin])
    }
    
    func updateBack() {
        background.texture = SKTexture(imageNamed: GameManager.shared.backgrounds[GameManager.shared.currBack])
    }
}
