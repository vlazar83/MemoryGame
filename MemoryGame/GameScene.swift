//
//  GameScene.swift
//  MemoryGame
//
//  Created by Lazar, Viktor on 17/07/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
//    override func sceneDidLoad() {
//
//        self.lastUpdateTime = 0
//        
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }
//    }
    
    
    var cardArray: [Card] = []
    
    override func didMove(to view: SKView) {
        setupCards()
    }
    
    func setupCards() {
        let cardPairs = 8
        let cardNames = (1...cardPairs).map { "card\($0)" } + (1...cardPairs).map { "card\($0)" }
        let shuffledCardNames = cardNames.shuffled()
        
        let columns = 4
        let rows = 4
        
        // Use the safe area insets to get the usable screen size
        let safeAreaInsets = view!.safeAreaInsets
        let usableWidth = self.size.width - safeAreaInsets.left - safeAreaInsets.right
        let usableHeight = self.size.height - safeAreaInsets.top - safeAreaInsets.bottom
        
        let cardWidth =  ( usableWidth * 0.7 ) / CGFloat(columns)
        let cardHeight = ( usableHeight * 0.7 ) / CGFloat(rows)

        let upperLeftCornerX = ( usableWidth * -0.6 ) / 2 + 30
        let upperLeftCornerY = ( usableHeight * 0.6 ) / 2
        
        for row in 0..<rows {
            for column in 0..<columns {
                let cardName = shuffledCardNames[row * columns + column]
                let card = Card(imageNamed: "cardBack")
                card.frontTexture = SKTexture(imageNamed: cardName)
                card.backTexture = SKTexture(imageNamed: "cardBack")
                card.size = CGSize(width: cardWidth - 10, height: cardHeight - 10)

                card.position = CGPoint(
                    x: upperLeftCornerX + ( cardWidth * (CGFloat(column) )) ,
                    y: upperLeftCornerY - ( cardHeight * (CGFloat(row) ))
                )
                cardArray.append(card)
                addChild(card)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if let card = node as? Card, !card.isFlipped && !card.isMatched {
                    card.flip()
                    checkForMatch(card)
                }
            }
        }
    }
    
    func checkForMatch(_ card: Card) {
        let flippedCards = cardArray.filter { $0.isFlipped && !$0.isMatched }
        
        if flippedCards.count == 2 {
            let firstCard = flippedCards[0]
            let secondCard = flippedCards[1]
            
            if firstCard.frontTexture == secondCard.frontTexture {
                firstCard.isMatched = true
                secondCard.isMatched = true
            } else {
                firstCard.flip()
                secondCard.flip()
            }
        }
    }
}
