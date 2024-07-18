//
//  GameScene.swift
//  MemoryGame
//
//  Created by Lazar, Viktor on 17/07/2024.
//

import SpriteKit
import GameplayKit
import Lottie


class GameScene: SKScene {
    
    var waitingForNextClick = false
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    var clicks = 0
    
    private var animationView : LottieAnimationView!
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    
    private var upperLeftCornerX = 0.0
    private var upperLeftCornerY = 0.0
    
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
        self.backgroundColor = SKColor.black
        setupCards()
        setupBackButton()
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
        
        let cardWidth =  ( usableWidth * 0.8 ) / CGFloat(columns)
        let cardHeight = ( usableHeight * 0.85 ) / CGFloat(rows)

        upperLeftCornerX = ( usableWidth * -0.6 ) / 2 + 5
        upperLeftCornerY = ( usableHeight * 0.6 ) / 2
        
        var counter = 0
        
        for row in 0..<rows {
            for column in 0..<columns {
                let cardName = shuffledCardNames[row * columns + column]
                let card = Card(imageNamed: "cardBack")
                card.frontTexture = SKTexture(imageNamed: cardName)
                card.backTexture = SKTexture(imageNamed: "cardBack")
                card.size = CGSize(width: cardWidth - 10, height: cardHeight - 10)
                card.row = row
                card.col = column
                card.id = counter

                card.position = CGPoint(
                    x: upperLeftCornerX + ( cardWidth * (CGFloat(column) )) ,
                    y: upperLeftCornerY - ( cardHeight * (CGFloat(row) ))
                )
                cardArray.append(card)
                addChild(card)
                counter+=1
            }
        }
    }
    
    func setupBackButton() {
        let backButton = SKLabelNode(text: "< Back")
        backButton.fontName = "Arial-BoldMT"
        backButton.fontSize = 30
        backButton.fontColor = .blue
//        backButton.position = CGPoint(x: upperLeftCornerX, y: upperLeftCornerY)
        backButton.position = CGPoint(x: -self.size.width / 2 + backButton.frame.width / 2 + 100, y: self.size.height / 2 - backButton.frame.height / 2 - 100)
//        backButton.position = CGPoint(x: 0.0, y: 0.0)
        backButton.name = "backButton"
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if waitingForNextClick {
                    // If waiting for the next click, do nothing
                    return
        }
        clicks += 1
        if let touch = touches.first {
            let location = touch.location(in: self)
            let tappedNodes = nodes(at: location)
            
            for node in tappedNodes {
                if node.name == "backButton" {
                                    let transition = SKTransition.fade(withDuration: 1.0)
                                    let menuScene = MenuScene(size: self.size)
                                    menuScene.scaleMode = .aspectFill
                                    view?.presentScene(menuScene, transition: transition)
                                }
                if let card = node as? Card, !card.isFlipped && !card.isMatched {
                    card.flip()
                    checkForMatch(card)
                }
            }
        }
    }
    
    func isGameWon() -> Bool {
        return cardArray.allSatisfy { $0.isMatched }
    }
    
    func checkForMatch(_ card: Card) {
        let waitAction = SKAction.wait(forDuration: 1.0)
        let flippedCards = cardArray.filter { $0.isFlipped && !$0.isMatched }
        
        if flippedCards.count == 2 {
            let firstCard = flippedCards[0]
            let secondCard = flippedCards[1]
            
            if firstCard.frontTexture.description == secondCard.frontTexture.description {
                firstCard.isMatched = true
                secondCard.isMatched = true
                let removeCardsAction = SKAction.run {
                    firstCard.removeFromParent()
                    secondCard.removeFromParent()
                    self.setupAnimationView ()
                    
                    if self.isGameWon() {
                        self.showResults()
                    }
                    
                }
            run(SKAction.sequence([waitAction, removeCardsAction]))
            } else {
                waitingForNextClick = true
                
                let flipBackAction = SKAction.run {
                    firstCard.flipBack()
                    secondCard.flipBack()
                    self.waitingForNextClick = false
                }
                run(SKAction.sequence([waitAction, flipBackAction]))

            }
        }
    }
    
    func showResults() {
        let transition = SKTransition.fade(withDuration: 1.0)
        let resultsScene = ResultsScene(size: self.size)
        resultsScene.clicks = clicks
        resultsScene.scaleMode = .aspectFill
        view?.presentScene(resultsScene, transition: transition)
    }
    
    func setupAnimationView (){
        animationView = .init(name: "disappear_animation")
        animationView.frame = view!.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        view?.addSubview(animationView)
        animationView.play()
    }
}
