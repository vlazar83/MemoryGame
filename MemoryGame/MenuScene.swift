//
//  MenuScene.swift
//  MemoryGame
//
//  Created by Lazar, Viktor on 18/07/2024.
//

import SpriteKit
import Lottie

class MenuScene: SKScene {
    
    private var animationView : LottieAnimationView!
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let titleLabel = SKLabelNode(text: "Memory Game")
        titleLabel.fontName = "Arial-BoldMT"
        titleLabel.fontSize = 40
        titleLabel.fontColor = .black
        titleLabel.position = CGPoint(x: frame.midX, y: frame.midY + 100)
        addChild(titleLabel)
        
        let startButton = SKLabelNode(text: "Start Playing")
        startButton.fontName = "Arial-BoldMT"
        startButton.fontSize = 30
        startButton.fontColor = .blue
        startButton.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        startButton.name = "startButton"
        addChild(startButton)
        
        setupAnimationView()
    }
    
    func setupAnimationView (){
        animationView = .init(name: "game_menu_animation")
        animationView.frame = view!.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.0
        view?.addSubview(animationView)
        animationView.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodes = nodes(at: location)
            
            for node in nodes {
                if node.name == "startButton" {
                    animationView.stop()
                    animationView.removeFromSuperview()
                    let transition = SKTransition.fade(withDuration: 1.0)
                    if let gameScene = GameScene(fileNamed: "GameScene") {
                        gameScene.scaleMode = .aspectFill
                        view?.presentScene(gameScene, transition: transition)
                    }
                }
            }
        }
    }
}
