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

    var currSkin: Int {
        get { UserDefaults.standard.integer(forKey: "skin") }
        set {
            UserDefaults.standard.set(newValue, forKey: "skin")
        }
    }
    
    var currBack: Int {
        get { UserDefaults.standard.integer(forKey: "background") }
        set {
            UserDefaults.standard.set(newValue, forKey: "background")
        }
    }
    
    var score: Int = 0
    var highscore: Int = 0
    var skins = ["monster", "robot", "cowboy", "cat"]
    var backgrounds = ["blueSky", "purple city", "hell", "space"]

    private init() {
        loadDefaults()
    }

    private func loadDefaults() {
        // Ensure the current skin and background indices are valid
        let skinIndex = UserDefaults.standard.integer(forKey: "skin")
        let backgroundIndex = UserDefaults.standard.integer(forKey: "background")
        // Reset to 0 if the indices are out of range
        if skinIndex >= skins.count || skinIndex < 0 {
            currSkin = 0
        } else {
            currSkin = skinIndex
        }

        if backgroundIndex >= backgrounds.count || backgroundIndex < 0 {
            currBack = 0
        } else {
            currBack = backgroundIndex
        }
    }
}
