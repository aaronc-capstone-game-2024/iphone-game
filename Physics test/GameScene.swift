//
//  GameScene.swift
//  Physics test
//
//  Created by Aaron C on 7/10/24.
//

import SpriteKit

struct PhysicsCategory {
    static let ground : UInt32 = 0x1 << 1
    static let monster : UInt32 = 0x1 << 2
}

class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    var monster = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        ground = SKSpriteNode(imageNamed: "wood")
        ground.size = CGSize(width: 3000, height: 200)
        ground.setScale(0.6)
        ground.position = CGPoint(x: self.frame.width / 2, y: ground.size.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.monster
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 0.4
        self.addChild(ground)
        
        monster = SKSpriteNode(imageNamed: "monster")
        monster.size = CGSize(width: 80, height: 90)
        monster.position = CGPoint(x: self.frame.width / 2 - monster.frame.width, y: self.frame.height / 2)
        
        monster.physicsBody = SKPhysicsBody(circleOfRadius: monster.frame.height / 2)
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster.physicsBody?.collisionBitMask = PhysicsCategory.ground
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.ground
        monster.physicsBody?.affectedByGravity = true
        monster.physicsBody?.isDynamic = true
        self.addChild(monster)
        
//        print(self.view!.bounds.width)
//        print(self.view!.bounds.height)

        print(self.frame.size.width)
        print(self.frame.size.height)

//        print(UIScreen.mainScreen().bounds.size.width)
//        print(UIScreen.mainScreen().bounds.size.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let monsterPosition = monster.position
                    
            // Calculate vector from monster to touch location
            let dx = touchLocation.x - monsterPosition.x
            let dy = touchLocation.y - monsterPosition.y
            let vector = CGVector(dx: dx, dy: dy)
                    
            // Normalize the vector to get direction
            let length = sqrt(dx*dx + dy*dy)
            let direction = CGVector(dx: vector.dx / length, dy: vector.dy / length)
                    
            // Apply impulse in the direction of the tap
            let impulseMagnitude: CGFloat = 200
            let impulse = CGVector(dx: direction.dx * impulseMagnitude, dy: direction.dy * impulseMagnitude)
            monster.physicsBody?.applyImpulse(impulse)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // update bird location to loop around screen
        if monster.position.x > 750.0 {
            monster.position.x = 0.0
        }
        if monster.position.x < 0.0 {
            monster.position.x = 750.0
        }
        if monster.position.y > 1334.0 {
            monster.position.y = ground.size.height / 2
        }
    }
}
