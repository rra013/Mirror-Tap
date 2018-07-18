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
    
    var visibleBall = SKSpriteNode()
    var tappableBall = SKShapeNode()
    var scoreLabel = SKLabelNode()
    var lost = false
    var scores = [[0], [0]]
    var defaults = UserDefaults.standard
    
    override func didMove(to view: SKView) {
        if let savedData = defaults.object(forKey: "dataz") as? Data{
            if let decoded = try? JSONDecoder().decode([[Int]].self, from: savedData){
                print("dec\(decoded)")
                scores = decoded
            }
        }
        print("hs:\(scores[1][0])")
        setUpBalls()
        setUpScoreLabel()
        setUpBackground()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if lost{
            setUpBalls()
            setUpScoreLabel()
            setUpBackground()

            lost = false
        }
        else{
            for touch in touches{
                let positionInScene = touch.location(in: self)
                let touchedNode = self.atPoint(positionInScene)
                
                if let name = touchedNode.name
                {
                    if name == "tappable"
                    {
                        setUpBalls()
                        scores[0][0] += 1
                        setUpScoreLabel()
                        setUpBackground()

                    }
                }
                else{
                    print("Loss")
                    lose()
                }
            }
            saveScore()
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

        var ballX = Int(arc4random_uniform(UInt32(frame.maxX-50)))
        var ballY = Int(arc4random_uniform(UInt32(frame.maxY-60)))
        if(ballY < 50){
            ballY = 60
        }
        let qSelector = arc4random_uniform(2)
        
        if(qSelector == 1){
            ballX *= -1
        }
        let circleSprite = SKTexture(imageNamed: "circle")
        visibleBall = SKSpriteNode(texture: circleSprite)
        tappableBall = SKShapeNode(circleOfRadius: 50)
        visibleBall.scale(to: CGSize(width: 100, height: 100))
        visibleBall.position = CGPoint(x: Int(ballX), y: Int(ballY))
        tappableBall.position = CGPoint(x: -ballX, y: -ballY)
        tappableBall.name = "tappable"
        tappableBall.alpha = 0.1
        
        addChild(visibleBall)
        addChild(tappableBall)
        print("BALL\n\(scores)")
    }
    
    func setUpScoreLabel(){
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        scoreLabel.fontSize = 100
        scoreLabel.fontColor = .black
        scoreLabel.text = String(scores[0][0])
        addChild(scoreLabel)
    }
    
    func setUpBackground(){
        let image = SKTexture(imageNamed: "background")
        let backgroundSprite = SKSpriteNode(texture: image)
        backgroundSprite.zPosition = -1
        backgroundSprite.position = CGPoint(x: 0, y: 0)
        addChild(backgroundSprite)
    }
    
    func saveScore(){
        if scores[0][0] > scores[1][0]{
            scores[1] = scores[0]
        }
        if let encoded = try? JSONEncoder().encode(scores){
            defaults.set(encoded, forKey : "dataz")
            print("saved")
        }
        print("saved?")
    }
    
    @IBAction func backClicked(_ sender: Any) {
        
    }
    
    func lose(){
        self.backgroundColor = UIColor(red:1.00, green:0.31, blue:0.31, alpha:1.0)
        scoreLabel.text = "You Lost!"
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.removeAllChildren()
        addChild(scoreLabel)
        saveScore()
        scores[0][0] = 0
        lost = true
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
