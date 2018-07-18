//
//  GameScene.swift
//  Mirror Tap
//
//  Created by Rishi Anand on 7/13/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    var visibleBall = SKSpriteNode()
    var tappableBall = SKShapeNode()
    
    var scoreLabel = SKLabelNode()
    
    var lost = false
    
    var score = 0
    
    var playMusic = true
    
    var audioPlayer: AVAudioPlayer?
    
    override func didMove(to view: SKView) {
        setUpBalls()
        setUpScoreLabel()
        setUpBackground()
        if playMusic{
            playSoundWithFileName(file: "MirrorTap", fileExt: "mp3")
        }
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
                        score += 1
                        setUpScoreLabel()
                        setUpBackground()

                    }
                }
                else{
                    print("Loss")
                    lose()
                }
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

        var ballX = Int(arc4random_uniform(UInt32(frame.maxX-50)))
        var ballY = Int(arc4random_uniform(UInt32(frame.maxY-50)))
        if(ballY < 50){
            ballY = 50
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
        print("BALL\n\(score)")
    }
    
    func setUpScoreLabel(){
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        scoreLabel.text = String(score)
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = .black
        addChild(scoreLabel)
    }
    
    func setUpBackground(){
        let image = SKTexture(imageNamed: "background")
        let backgroundSprite = SKSpriteNode(texture: image)
        backgroundSprite.zPosition = -1
        backgroundSprite.position = CGPoint(x: 0, y: 0)
        addChild(backgroundSprite)
    }
    
    func lose(){
        self.backgroundColor = .red
        scoreLabel.text = "FAT L"
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.removeAllChildren()
        addChild(scoreLabel)
        score = 0
        lost = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    func playSoundWithFileName(file: String, fileExt: String)-> Void {
        let audioSourceURL: URL!
        
        audioSourceURL = Bundle.main.url(forResource: file, withExtension: fileExt)
        
        if audioSourceURL == nil{
            print("No Audio")
        }
        else{
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: audioSourceURL!)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch{
                print(error)
            }
        }
    }
}
