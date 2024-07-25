//
//  GameManager.swift
//  iphone game
//
//  Created by Aaron C on 7/24/24.
//

import Foundation
import SpriteKit

class GameManager {
    static let shared = GameManager()
    
    private init() {}
    
    var score: Int = 0
    var highscore: Int = 12
    var skins = [SKSpriteNode()]
    var backgrounds = [SKSpriteNode()]
}
