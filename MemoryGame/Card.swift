//
//  Card.swift
//  MemoryGame
//
//  Created by Lazar, Viktor on 17/07/2024.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    var id : Int = 0
    var row : Int = 0
    var col : Int = 0
    var isFlipped = false
    var isMatched = false
    var frontTexture: SKTexture!
    var backTexture: SKTexture!
    
    func flip() {
        let flip = SKAction.scaleX(to: 0.0, duration: 0.2)
        let unflip = SKAction.scaleX(to: 1.0, duration: 0.2)
        let changeTexture = SKAction.run {
            //self.texture = self.isFlipped ? self.backTexture : self.frontTexture
            self.texture = self.frontTexture
        }
        let flipSequence = SKAction.sequence([flip, changeTexture, unflip])
        run(flipSequence)
        isFlipped.toggle()
    }
    
    func flipBack() {
        let flip = SKAction.scaleX(to: 0.0, duration: 0.2)
        let unflip = SKAction.scaleX(to: 1.0, duration: 0.2)
        let changeTexture = SKAction.run {
            //self.texture = self.isFlipped ? self.backTexture : self.frontTexture
            self.texture = self.backTexture
        }
        let flipSequence = SKAction.sequence([flip, changeTexture, unflip])
        run(flipSequence)
        isFlipped.toggle()
    }
}
