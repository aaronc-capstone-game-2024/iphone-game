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
    var highscore: Int = 0
    var skins = ["monster1"]
    var backgrounds = ["blueSky"]
    var currSkin = 0
    var currBack = 0
}
