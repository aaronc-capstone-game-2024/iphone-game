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
                testLabel.fontName = "Helvetica"
                testLabel.horizontalAlignmentMode = .center
                testLabel.calculateAccumulatedFrame()

                if testLabel.frame.size.width > maxWidth {
                    let lineLabel = SKLabelNode(text: currentLine)
                    lineLabel.fontSize = 14
                    lineLabel.fontName = "Helvetica"
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
                lineLabel.fontName = "Helvetica"
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
        let howToPlay = SKLabelNode(text: "lemme teach you sum")
        howToPlay.position = CGPoint(x: frame.midX, y: frame.maxY - howToPlay.frame.size.height / 2 - 100)
        addChild(howToPlay)
        
        // item info
        let bulletText = SKLabelNode(text: "bulletz are good")
        let bulletImg = SKSpriteNode(imageNamed: "bullet")
        bulletText.position = CGPoint(x: frame.midX, y: frame.maxY - 200)
        bulletImg.size = CGSize(width: 60, height: 60)
        bulletImg.position = CGPoint(x: bulletText.frame.minX - bulletImg.frame.size.width / 2, y: bulletText.frame.midY)
        addChild(bulletText)
        addChild(bulletImg)
        
        let coinText = SKLabelNode(text: "coinz are good")
        let coinImg = SKSpriteNode(imageNamed: "coin")
        coinText.position = CGPoint(x: frame.midX, y: frame.maxY - 250)
        coinImg.size = CGSize(width: 60, height: 60)
        coinImg.position = CGPoint(x: coinText.frame.minX - coinImg.frame.size.width / 2, y: coinText.frame.midY)
        addChild(coinText)
        addChild(coinImg)
        
        let bombText = SKLabelNode(text: "bombz are bad")
        let bombImg = SKSpriteNode(imageNamed: "bomb")
        bombText.position = CGPoint(x: frame.midX, y: coinText.position.y - 50)
        bombImg.size = CGSize(width: 60, height: 60)
        bombImg.position = CGPoint(x: bombText.frame.minX - bombImg.frame.size.width / 2, y: bombText.frame.midY)
        addChild(bombText)
        addChild(bombImg)
        
        // rotate explanation
        let rotateText = "rotate around the screen to show how cool you are rotate around the screen to show how cool you are"
        let rotate = createMultilineLabel(text: rotateText, maxWidth: maxWidth, lineHeight: 20)
        rotate.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(rotate)
        
        //explain the special
        
        
        // got it button
        //change to button or image
        exit.position = CGPoint(x: frame.midX, y: frame.minY + 100)
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
