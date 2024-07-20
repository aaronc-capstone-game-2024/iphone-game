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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var character = SKSpriteNode()
    var bullet = SKSpriteNode()
    var labelClicks = SKLabelNode(fontNamed: "AvenirNext-Bold")
    
    var clicks = 5
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
//        self.anchorPoint = CGPoint(x: 0, y: 0)
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        character = SKSpriteNode(imageNamed: "monster")
        character.size = CGSize(width: 80, height: 90)
        character.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        character.physicsBody = SKPhysicsBody(circleOfRadius: character.frame.height / 2)
        character.physicsBody?.categoryBitMask = PhysicsCategory.character
        character.physicsBody?.collisionBitMask = 0  // No collision with other bodies
        character.physicsBody?.contactTestBitMask = PhysicsCategory.bullet  // Notify on contact with bullet
        character.physicsBody?.affectedByGravity = false
        character.physicsBody?.isDynamic = true
        self.addChild(character)
                
        bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.size = CGSize(width: 50, height: 50)
        bullet.position = CGPoint(x: self.frame.midX / 3, y: self.frame.height / 2)
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.isDynamic = false  // Ensure bullet doesn't move under physics simulation
        bullet.physicsBody?.categoryBitMask = PhysicsCategory.bullet
        bullet.physicsBody?.contactTestBitMask = PhysicsCategory.character
        bullet.physicsBody?.collisionBitMask = 0  // No need to collide with anything
        self.addChild(bullet)
        
        //display clicks
        displayClick()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.character && secondBody.categoryBitMask == PhysicsCategory.bullet
            || firstBody.categoryBitMask == PhysicsCategory.bullet && secondBody.categoryBitMask == PhysicsCategory.character
        {
            clicks+=1
            updateClick()
            
            if clicks > 0 {
                self.isUserInteractionEnabled = true
            }
            bullet.removeFromParent()
        }
        
        // handle 0 clicks but bullet gained
        if clicks == 0 && (firstBody.categoryBitMask == PhysicsCategory.character && secondBody.categoryBitMask == PhysicsCategory.bullet) || clicks == 0 && (firstBody.categoryBitMask == PhysicsCategory.bullet && secondBody.categoryBitMask == PhysicsCategory.character) {
            self.isUserInteractionEnabled = true
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
            
            //Decrement clicks
            clicks -= 1
            updateClick()
            
            if clicks == 0 {
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Update instead of hard values -> frame of phone
        // check character position
        if character.position.x > 450.0 {
            character.position.x = 0.0
        }
        if character.position.x < 0.0 {
            character.position.x = 450.0
        }
        if character.position.y > 1000.0 {
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
        
        // Update clicks and handle 0 clicks
        updateClick()
        if clicks == 0 {
            self.isUserInteractionEnabled = false
        }
    }
    
    func switchScene() {
        let scene = MenuScene(size: self.size)
        view?.presentScene(scene)
    }
    
    func displayClick() {
        labelClicks.text = "\(clicks)"
        labelClicks.fontColor = .white
        labelClicks.fontSize = 60
        labelClicks.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(labelClicks)
    }
    
    func updateClick() {
        labelClicks.text = "\(clicks)"
    }
}
