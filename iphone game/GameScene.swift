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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var character = SKSpriteNode()
    var bulletsArray = [SKSpriteNode()]
    var coinsArray = [SKSpriteNode()]
    var labelClicks = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    var clicks = 5
    var bulletCount = 2
    var coinCount = 2
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        character = SKSpriteNode(imageNamed: "monster")
        character.size = CGSize(width: 80, height: 90)
        character.position = CGPoint(x: frame.midX, y: frame.midY)
        character.physicsBody = SKPhysicsBody(circleOfRadius: character.frame.height / 2)
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.collisionBitMask = 0
        character.physicsBody?.contactTestBitMask = PhysicsCategory.bullet
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.isDynamic = true
        self.addChild(character)
                
        createBullets()
        createCoins()
        displayClick()
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
        
        if character.position.x > maxWidth {
            character.position.x = 0.0
        }
        if character.position.x < 0.0 {
            character.position.x = maxWidth
        }
        if character.position.y > maxHeight {
            character.position.y = 10.0
        }
        if character.position.y < -10.0 {
            let gameover = SKLabelNode(text: "Game Over")
            gameover.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            addChild(gameover)
            character.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            let wait = SKAction.wait(forDuration: 1.5)
            let transition = SKAction.run {
                self.switchScene()
            }
            self.run(SKAction.sequence([wait, transition]))
        }
        
        updateClick()
        if clicks == 0 {
            self.isUserInteractionEnabled = false
        }
    }
    
    func createBullets() {
        bulletsArray.removeAll()
        
        for _ in 0...bulletCount {
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.size = CGSize(width: 50, height: 50)
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody?.isDynamic = false
            bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            bullet.physicsBody?.contactTestBitMask = PhysicsCategory.character
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
            
            let randomX = CGFloat.random(in: 1...self.frame.width - 80)
            let randomY = CGFloat.random(in: 1...self.frame.height - 80)
            bullet.position = CGPoint(x: randomX, y: randomY)
            addChild(bullet)
        }
    }
    
    func createCoins() {
        coinsArray.removeAll()
        
        for _ in 0...coinCount {
            let coin = SKSpriteNode(imageNamed: "coin")
            coin.size = CGSize(width: 50, height: 50)
            coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
            coin.physicsBody?.isDynamic = false
            coin.physicsBody?.categoryBitMask = PhysicsCategory.coin
            coin.physicsBody?.contactTestBitMask = PhysicsCategory.character
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
            
            let randomX = CGFloat.random(in: 1...self.frame.width - 80)
            let randomY = CGFloat.random(in: 1...self.frame.height - 80)
            coin.position = CGPoint(x: randomX, y: randomY)
            addChild(coin)
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
}
