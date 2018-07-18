//
//  HighScoreViewController.swift
//  Mirror Tap
//
//  Created by Jaden Garrett on 7/16/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import UIKit
import AVFoundation

var playMusic = true //global

class HighScoreViewController: UIViewController {
    var scores = [[0], [0]]
    var defaults = UserDefaults.standard
    var audioPlayer: AVAudioPlayer?
    //var playMusic = true
    @IBOutlet weak var hardHighscore: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedData = defaults.object(forKey: "dataz") as? Data{
            if let decoded = try? JSONDecoder().decode([[Int]].self, from: savedData){
                print("dec\(decoded)")
                scores = decoded
            }
            if playMusic {
                playSoundWithFileName(file: "MirrorTap", fileExt: "mp3")
                playMusic = false
            }
        }
        hardHighscore.text = "Highscore: \(scores[1][0])"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func muteButtonTapped(_ sender: Any) {
        if soundButton.currentImage == #imageLiteral(resourceName: "speaker"){
            audioPlayer?.pause()
            soundButton.setImage(#imageLiteral(resourceName: "speakerMuted"), for: .normal)
        }
        else{
            audioPlayer?.play()
            soundButton.setImage(#imageLiteral(resourceName: "speaker"), for: .normal)
        }
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
