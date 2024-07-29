//
//  Tutorial.swift
//  iphone game
//
//  Created by Aaron C on 7/27/24.
//

import SpriteKit

class Tutorial: SKScene {
    let exit = SKLabelNode(text: "got it")
    
    func createMultilineLabel(text: String, maxWidth: CGFloat, lineHeight: CGFloat) -> SKNode {
            let words = text.components(separatedBy: " ")
            var currentLine = ""
            let containerNode = SKNode()

            var currentHeight: CGFloat = 0
            for word in words {
                let testLine = currentLine + (currentLine.isEmpty ? "" : " ") + word
                let testLabel = SKLabelNode(text: testLine)
                testLabel.fontSize = 14
                testLabel.fontName = "Optima-ExtraBlack"
                testLabel.horizontalAlignmentMode = .center
                testLabel.calculateAccumulatedFrame()

                if testLabel.frame.size.width > maxWidth {
                    let lineLabel = SKLabelNode(text: currentLine)
                    lineLabel.fontSize = 14
                    lineLabel.fontName = "Optima-ExtraBlack"
                    lineLabel.horizontalAlignmentMode = .center
                    lineLabel.position = CGPoint(x: 0, y: -currentHeight)
                    containerNode.addChild(lineLabel)
                    currentLine = word
                    currentHeight += lineHeight
                } else {
                    currentLine = testLine
                }
            }

            if !currentLine.isEmpty {
                let lineLabel = SKLabelNode(text: currentLine)
                lineLabel.fontSize = 14
                lineLabel.fontName = "Optima-ExtraBlack"
                lineLabel.horizontalAlignmentMode = .center
                lineLabel.position = CGPoint(x: 0, y: -currentHeight)
                containerNode.addChild(lineLabel)
            }

            return containerNode
        }
    
    override func didMove(to view: SKView) {
        let margin: CGFloat = 50  // Margin on each side
        let maxWidth = frame.width - 2 * margin
        
        // how to play
        let howToPlay = SKLabelNode(text: "Instructions")
        howToPlay.position = CGPoint(x: frame.midX, y: frame.maxY - howToPlay.frame.size.height / 2 - 100)
        howToPlay.fontName = "Optima-ExtraBlack"
        howToPlay.color = .white
        addChild(howToPlay)
        
        let instructionText = "you start the game with 10 jumps, youre objective is to grab as many coins and bullets without falling off the bottom of the map or hitting a bomb."
        let instructions = createMultilineLabel(text: instructionText, maxWidth: maxWidth, lineHeight: 20)
        instructions.position =  CGPoint(x: frame.midX, y: frame.maxY - 150)
        addChild(instructions)
        
        // item info
        let bulletText = SKLabelNode(text: "+1 jump & +2 points")
        let bulletImg = SKSpriteNode(imageNamed: "bullet")
        bulletText.position = CGPoint(x: frame.midX, y: frame.maxY - 250)
        bulletText.fontSize = 18
        bulletText.fontName = "Optima-ExtraBlack"
        bulletImg.size = CGSize(width: 60, height: 60)
        bulletImg.position = CGPoint(x: bulletText.frame.minX - bulletImg.frame.size.width / 2, y: bulletText.frame.midY)
        addChild(bulletText)
        addChild(bulletImg)
        
        let coinText = SKLabelNode(text: "+1 coin & +5 points")
        let coinImg = SKSpriteNode(imageNamed: "coin")
        coinText.position = CGPoint(x: frame.midX, y: bulletText.position.y - 50)
        coinText.fontName = "Optima-ExtraBlack"
        coinText.fontSize = 18
        coinImg.size = CGSize(width: 60, height: 60)
        coinImg.position = CGPoint(x: coinText.frame.minX - coinImg.frame.size.width / 2, y: coinText.frame.midY)
        addChild(coinText)
        addChild(coinImg)
        
        let bombText = SKLabelNode(text: "death")
        let bombImg = SKSpriteNode(imageNamed: "bomb")
        bombText.position = CGPoint(x: frame.midX, y: coinText.position.y - 50)
        bombText.fontName = "Optima-ExtraBlack"
        bombText.fontSize = 18
        bombImg.size = CGSize(width: 60, height: 60)
        bombImg.position = CGPoint(x: bombText.frame.minX - bombImg.frame.size.width / 2, y: bombText.frame.midY)
        addChild(bombText)
        addChild(bombImg)
        
        // rotate explanation
        let proTip = SKLabelNode(text: "Pro Tip")
        proTip.fontName = "Optima-ExtraBlack"
        proTip.fontSize = 20
        proTip.position = CGPoint(x: frame.midX, y: bombText.position.y - 50)
        addChild(proTip)
        let rotateText = "you can rotate horizontally around the screen to grab items and vertically rotate by jumping above the top of the screen"
        let rotate = createMultilineLabel(text: rotateText, maxWidth: maxWidth, lineHeight: 20)
        rotate.position = CGPoint(x: frame.midX, y: proTip.position.y - 20)
        addChild(rotate)
        
        //explain the special
        let special = SKLabelNode(text: "Special")
        special.fontName = "Optima-ExtraBlack"
        special.fontSize = 20
        special.position = CGPoint(x: frame.midX, y: rotate.position.y - 80)
        addChild(special)
        
        // got it button
        //change to button or image
        exit.position = CGPoint(x: frame.midX, y: frame.minY + 50)
        exit.fontName = "Optima-ExtraBlack"
        addChild(exit)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            
            if exit.frame.contains(touchLocation) {
                let scene = MenuScene(size: CGSize(width: self.frame.width, height: self.frame.height))
                view!.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))  
            }
        }
    }
}
