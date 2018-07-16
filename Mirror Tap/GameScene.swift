//
//  GameScene.swift
//  Mirror Tap
//
//  Created by Rishi Anand on 7/13/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var visibleBall = SKShapeNode()
    var tappableBall = SKShapeNode()
    var score = 0
    
    override func didMove(to view: SKView) {
        setUpBalls()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
    
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            
            if let name = touchedNode.name
            {
                if name == "tappable"
                {
                    setUpBalls()
                }
            }
            else{
                print("Loss")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func setUpBalls(){
        removeAllChildren()
        var ballX = Int(arc4random_uniform(UInt32(frame.maxX)))
        let ballY = Int(arc4random_uniform(UInt32(frame.maxY)))
        let qSelector = arc4random_uniform(2)
        
        if(qSelector == 1){
            ballX *= -1
        }
        
        visibleBall = SKShapeNode(circleOfRadius: 100)
        tappableBall = SKShapeNode(circleOfRadius: 100)
        visibleBall.lineWidth = 1
        visibleBall.fillColor = .blue
        visibleBall.strokeColor = .white
        visibleBall.glowWidth = 0.5
        visibleBall.position = CGPoint(x: Int(ballX), y: Int(ballY))
        tappableBall.position = CGPoint(x: -ballX, y: -ballY)
        
        tappableBall.name = "tappable"
        
        addChild(visibleBall)
        addChild(tappableBall)
        print("BALL")
    }
   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
