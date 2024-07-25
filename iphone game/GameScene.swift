//
//  GameScene.swift
//  Physics test
//
//  Created by Aaron C on 7/10/24.
//

import SpriteKit

struct PhysicsCategory {
    static let character : UInt32 = 0x1 << 1
    static let bullet : UInt32 = 0x1 << 2
    static let coin : UInt32 = 0x1 << 3
    static let bomb : UInt32 = 0x1 << 4
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }

    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var character = SKSpriteNode()
    var bulletsArray = [SKSpriteNode()]
    var coinsArray = [SKSpriteNode()]
    var bombsArray = [SKSpriteNode()]
    var labelClicks = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var scoreLabel = SKLabelNode(text: "Score: \(GameManager.shared.score)")
    var coinLabel = SKLabelNode(text: "0")
    var tapLabel = SKLabelNode(text: "TAP!")
    
    var clicks = 10
    var bulletCount = 3
    var coinCount = 3
    var bombCount = 0
    var currCoins = 0
    
    var upgradedAt100 = false
    var upgradedAt150 = false
    var upgradedAt200 = false
    var upgradedAt250 = false
    
    var itemPosition: [String: [CGPoint]] = [
        "coins": [],
        "bullets": [],
        "bombs": []
    ]
    
    func positionOverlaps(_ newPosition: CGPoint) -> Bool {
        let safeZoneRadius: CGFloat = 50 // adjust radius as necessary

        for (_, positions) in itemPosition {
            for position in positions {
                if (position - newPosition).length() <= safeZoneRadius {
                    return true
                }
            }
        }
        return false
    }
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        character = SKSpriteNode(imageNamed: "monster")
        character.size = CGSize(width: 80, height: 90)
        character.position = CGPoint(x: frame.midX, y: frame.midY)
        character.physicsBody = SKPhysicsBody(circleOfRadius: character.frame.height / 2.35)
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.collisionBitMask = 0
        character.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.isDynamic = true
        self.addChild(character)
        
        tapLabel.fontSize = 100
        tapLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        tapLabel.color = UIColor(white: 1.0, alpha: 0.5)
        addChild(tapLabel)
                
        createBullets()
        createCoins()
        createBombs()
        displayClick()
        scoreCoinLabels()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //character bullet contact logic
        var bulletBody: SKPhysicsBody?
        if contact.bodyA.categoryBitMask == PhysicsCategory.bullet && contact.bodyB.categoryBitMask == PhysicsCategory.character {
            bulletBody = contact.bodyA
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.character && contact.bodyB.categoryBitMask == PhysicsCategory.bullet {
            bulletBody = contact.bodyB
        }

        if let bulletNode = bulletBody?.node as? SKSpriteNode, let index = bulletsArray.firstIndex(of: bulletNode) {
            
            bulletNode.removeFromParent()
            bulletsArray.remove(at: index)

            // clicks and bullets count logic
            clicks += 1
            updateClick()

            if clicks > 0 {
                self.isUserInteractionEnabled = true
            }

            bulletCount -= 1
            if bulletCount < 0 {
                bulletCount = 2
                createBullets()
            }
            
            GameManager.shared.score += 2
            updateScore()

            // enable interaction if clicks == 0 but character contact bullet
            if clicks == 0 && bulletBody != nil {
                self.isUserInteractionEnabled = true
            }
        }
        
        // character coin contact logic
        var coinBody : SKPhysicsBody?
        if contact.bodyA.categoryBitMask == PhysicsCategory.coin && contact.bodyB.categoryBitMask == PhysicsCategory.character {
            coinBody = contact.bodyA
        } else if contact.bodyB.categoryBitMask == PhysicsCategory.coin && contact.bodyA.categoryBitMask == PhysicsCategory.character {
            coinBody = contact.bodyB
        }
        
        if let coinNode = coinBody?.node as? SKSpriteNode, let index = coinsArray.firstIndex(of: coinNode) {
            
            coinNode.removeFromParent()
            coinsArray.remove(at: index)
            
            coinCount -= 1
            if coinCount < 0 {
                coinCount = 2
                createCoins()
            }
            
            GameManager.shared.score += 5
            currCoins += 1
            updateScore()
        }
        
        // character bomb contact logic
        var bombBody : SKPhysicsBody?
        if contact.bodyA.categoryBitMask == PhysicsCategory.bomb && contact.bodyB.categoryBitMask == PhysicsCategory.character {
            bombBody = contact.bodyA
        } else if contact.bodyA.categoryBitMask == PhysicsCategory.character && contact.bodyB.categoryBitMask == PhysicsCategory.bomb {
            bombBody = contact.bodyB
        }
        
        if bombBody?.node is SKSpriteNode {
            // when adding more bombs in the logic then create index
            
            let gameover = SKLabelNode(text: "Game Over")
            gameover.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(gameover)
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            character.physicsBody?.affectedByGravity = false
            isUserInteractionEnabled = false
            
            let wait = SKAction.wait(forDuration: 1.5)
            let transition = SKAction.run {
                self.switchScene()
            }
            self.run(SKAction.sequence([wait, transition]))
            if GameManager.shared.score > GameManager.shared.highscore {
                GameManager.shared.highscore = GameManager.shared.score
            }
            GameManager.shared.score = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tapLabel.removeFromParent()
        if clicks > 0 {
            character.physicsBody?.affectedByGravity = true
            if let touch = touches.first {
                let touchLocation = touch.location(in: self)
                let monsterPosition = character.position
                
                // Calculate vector from monster to touch location
                let dx = touchLocation.x - monsterPosition.x
                let dy = touchLocation.y - monsterPosition.y
                let vector = CGVector(dx: dx, dy: dy)
                
                // Normalize the vector to get direction
                let length = sqrt(dx*dx + dy*dy)
                let direction = CGVector(dx: vector.dx / length, dy: vector.dy / length)
                
                // Apply impulse in the direction of the tap
                let impulseMagnitude: CGFloat = 180
                let impulse = CGVector(dx: direction.dx * impulseMagnitude, dy: direction.dy * impulseMagnitude)
                character.physicsBody?.applyImpulse(impulse)
                character.physicsBody?.linearDamping = 1.0
            }
            
            //decrement clicks
            clicks -= 1
            updateClick()
            
            if clicks == 0 {
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // check character position
        let maxWidth = self.frame.width
        let maxHeight = self.frame.height
        
        if character.position.x > maxWidth + 10 {
            character.position.x = 0.0
        }
        if character.position.x < -10.0 {
            character.position.x = maxWidth
        }
        if character.position.y > maxHeight {
            character.position.y = 10.0
        }
        if character.position.y < -20.0 {
            let gameover = SKLabelNode(text: "Game Over")
            gameover.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(gameover)
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            let wait = SKAction.wait(forDuration: 1.5)
            let transition = SKAction.run {
                self.switchScene()
            }
            self.run(SKAction.sequence([wait, transition]))
            if GameManager.shared.score > GameManager.shared.highscore {
                GameManager.shared.highscore = GameManager.shared.score
            }
            GameManager.shared.score = 0
        }
        
        updateClick()
        if clicks == 0 {
            self.isUserInteractionEnabled = false
        }
        
    }
    
    func createBullets() {
        bulletsArray.forEach { $0.removeFromParent() }
        bulletsArray.removeAll()
        
        for _ in 0...bulletCount {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.size = CGSize(width: 50, height: 50)
            bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bullet.frame.width / 1.7, height: bullet.frame.height / 1.4))
            bullet.physicsBody?.isDynamic = false
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.character | PhysicsCategory.bomb
            bullet.physicsBody?.collisionBitMask = 0
            bulletsArray.append(bullet)
        }
        
        spawnBullets()
    }

    func spawnBullets() {
        for bullet in bulletsArray {
            if bullet.parent != nil {
                bullet.removeFromParent()
            }
            
            var newBulletPosition: CGPoint
            repeat {
                newBulletPosition = CGPoint(
                    x: CGFloat.random(in: 0..<self.frame.width - 50),
                    y: CGFloat.random(in: 0..<self.frame.height - 50)
                )
            } while positionOverlaps(newBulletPosition)

            bullet.position = newBulletPosition
            itemPosition["bullets"]?.append(newBulletPosition)
            addChild(bullet)
        }
    }
    
    func createCoins() {
        coinsArray.forEach { $0.removeFromParent() }
        coinsArray.removeAll()
        
        for _ in 0...coinCount {
            let coin = SKSpriteNode(imageNamed: "coin")
            coin.size = CGSize(width: 50, height: 50)
            coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.frame.height / 2.5)
            coin.physicsBody?.isDynamic = false
            coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
            coin.physicsBody?.contactTestBitMask = PhysicsCategory.character | PhysicsCategory.bomb
            coin.physicsBody?.collisionBitMask = 0
            coinsArray.append(coin)
        }
        
        spawnCoins()
    }
    
    func spawnCoins() {
        for coin in coinsArray {
            if coin.parent != nil {
                coin.removeFromParent()
            }
            
            var newCoinPosition: CGPoint
            repeat {
                newCoinPosition = CGPoint(
                    x: CGFloat.random(in: 0..<self.frame.width - 50),
                    y: CGFloat.random(in: 0..<self.frame.height - 50)
                )
            } while positionOverlaps(newCoinPosition)

            coin.position = newCoinPosition
            itemPosition["coins"]?.append(newCoinPosition)
            addChild(coin)
        }
    }
    
    func createBombs() {
        bombsArray.forEach { $0.removeFromParent() }
        bombsArray.removeAll()
        
        for _ in 0...bombCount {
            let bomb = SKSpriteNode(imageNamed: "bomb")
            bomb.size = CGSize(width: 50, height: 50)
            bomb.physicsBody = SKPhysicsBody(circleOfRadius: bomb.frame.height / 2.5)
            bomb.physicsBody?.isDynamic = false
            bomb.physicsBody?.categoryBitMask = PhysicsCategory.bomb
            bomb.physicsBody?.contactTestBitMask = PhysicsCategory.character
            bomb.physicsBody?.collisionBitMask = 0
            bombsArray.append(bomb)
        }
        
        spawnBombs()
    }
    
    func spawnBombs() {
        for bomb in bombsArray {
            if bomb.parent != nil {
                bomb.removeFromParent()
            }
            
            var newBombPosition: CGPoint
            repeat {
                newBombPosition = CGPoint(
                    x: CGFloat.random(in: 0..<self.frame.width - 30),
                    y: CGFloat.random(in: 0..<self.frame.height - 50)
                )
            } while positionOverlaps(newBombPosition)

            bomb.position = newBombPosition
            itemPosition["bombs"]?.append(newBombPosition)
            addChild(bomb)
        }
    }
    
    func switchScene() {
        let scene = MenuScene(size: self.size)
        view?.presentScene(scene)
    }
    
    func displayClick() {
        labelClicks.text = "\(clicks)"
        labelClicks.fontColor = UIColor(displayP3Red: 30.0, green: 12.1, blue: 102.3, alpha: 0.5)
        labelClicks.fontSize = 100
        labelClicks.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(labelClicks)
    }
    
    func updateClick() {
        labelClicks.text = "\(clicks)"
    }
    
    func scoreCoinLabels() {
        scoreLabel.position = CGPoint(x: self.frame.midX - 130, y: self.frame.size.height - 100)
        scoreLabel.fontSize = 25
        addChild(scoreLabel)
        
        coinLabel.position = CGPoint(x: self.frame.midX + 130, y: self.frame.size.height - 100)
        coinLabel.fontSize = 25
        let coinImage = SKSpriteNode(imageNamed: "coin")
        coinImage.size = CGSize(width: 35, height: 35)
        coinImage.position =  CGPoint(x: coinLabel.frame.minX - coinImage.size.width / 2 - 10, y: coinLabel.frame.midY)
        addChild(coinLabel)
        addChild(coinImage)
    }
    
    func updateScore() {
        scoreLabel.text = "Score: \(GameManager.shared.score)"
        coinLabel.text = "\(currCoins)"
                
        // score logic
        if GameManager.shared.score >= 100 && !upgradedAt100 {
            bulletCount = 2
            coinCount = 2
            createBullets()
            createCoins()
            upgradedAt100 = true
        }
                
        if GameManager.shared.score >= 150 && !upgradedAt150 {
            bombCount = 1
            createBombs()
            upgradedAt150 = true
        }
                
        if GameManager.shared.score >= 200 && !upgradedAt200 {
            bulletCount = 1
            coinCount = 1
            createBullets()
            createCoins()
            upgradedAt200 = true
        }
                
        if GameManager.shared.score >= 250 && !upgradedAt250 {
            bombCount = 2
            createBombs()
            upgradedAt250 = true
        }
    }
    
}
