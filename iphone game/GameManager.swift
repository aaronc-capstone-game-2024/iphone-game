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
    
    var currSkin: Int = UserDefaults.standard.integer(forKey: "skin") {
        didSet {
            UserDefaults.standard.set(currSkin, forKey: "skin")
            UserDefaults.standard.synchronize()
        }
    }
    
    var currBack: Int = UserDefaults.standard.integer(forKey: "background") {
        didSet {
            UserDefaults.standard.set(currBack, forKey: "background")
            UserDefaults.standard.synchronize()
        }
    }
    
    var score: Int = 0
    var highscore: Int = 0
    var skins = ["monster", "robot", "cowboy", "cat"]
    var backgrounds = ["blueSky", "purple city", "hell", "space"]

    private init() {
        currSkin = UserDefaults.standard.integer(forKey: "skin")
        currBack = UserDefaults.standard.integer(forKey: "background")
    }
}
