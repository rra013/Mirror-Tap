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
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
    var visibleBall = SKSpriteNode()
    var tappableBall = SKShapeNode()
    var scoreLabel = SKLabelNode()
    var timerLabel = SKLabelNode()
    var lost = false
    var scores = [[0], [0]]
    var defaults = UserDefaults.standard
    var countDownTimer = Timer()
    var timeRemaining = 5.0
    var originalTime = 5.0

    
    override func didMove(to view: SKView) {
        timeRemaining = originalTime
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
        setUpTimer()
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
            setUpTimer()
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
                        setUpTimer()
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
        countDownTimer.invalidate()
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
        if(GameScene.modelName == "iPhone X" || GameScene.modelName == "Simulator iPhone X"){
            print(GameScene.modelName)
            scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        }
        else{
            print(GameScene.modelName)
        }
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
    
    @objc func lose(){
        self.backgroundColor = UIColor(red:1.00, green:0.31, blue:0.31, alpha:1.0)
        scoreLabel.text = "You Lost!"
        scoreLabel.fontSize = 100
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        self.removeAllChildren()
        addChild(scoreLabel)
        saveScore()
        scores[0][0] = 0
        countDownTimer.invalidate()
        lost = true
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    @objc func updateCountdown(){
        timeRemaining -= 0.1
        if(timeRemaining <= 0){
            countDownTimer.invalidate()
            timeRemaining = originalTime
            lose()
        }
        timerLabel.text = String(format: "%.1f", timeRemaining)
    }
    
    func setUpTimer(){
        timerLabel.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        timerLabel.fontSize = 100
        timeRemaining = originalTime
        countDownTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(updateCountdown)), userInfo: nil, repeats: true)
        addChild(timerLabel)
        tappableBall.zPosition = 1
    }
    
}
