//
//  ResultsScene.swift
//  MemoryGame
//
//  Created by Lazar, Viktor on 18/07/2024.
//

import SpriteKit

class ResultsScene: SKScene {
    var clicks: Int = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let titleLabel = SKLabelNode(text: "Game Over")
        titleLabel.fontName = "Arial-BoldMT"
        titleLabel.fontSize = 40
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(titleLabel)
        
        let clicksLabel = SKLabelNode(text: "Total Clicks: \(clicks)")
        clicksLabel.fontName = "Arial"
        clicksLabel.fontSize = 30
        clicksLabel.fontColor = .black
        clicksLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(clicksLabel)
        
        let menuButton = SKLabelNode(text: "Back to Menu")
        menuButton.fontName = "Arial-BoldMT"
        menuButton.fontSize = 30
        menuButton.fontColor = .blue
        menuButton.position = CGPoint(x: frame.midX, y: frame.midY - 100)
        menuButton.name = "menuButton"
        addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = nodes(at: location)
            
            for node in nodes {
                if node.name == "menuButton" {
                    let transition = SKTransition.fade(withDuration: 1.0)
                    let menuScene = MenuScene(size: self.size)
                    menuScene.scaleMode = .aspectFill
                    view?.presentScene(menuScene, transition: transition)
                }
            }
        }
    }
}
