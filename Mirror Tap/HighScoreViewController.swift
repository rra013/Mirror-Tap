//
//  HighScoreViewController.swift
//  Mirror Tap
//
//  Created by Jaden Garrett on 7/16/18.
//  Copyright © 2018 Rishi Anand. All rights reserved.
//

import UIKit

class HighScoreViewController: UIViewController {
    var highscore = [0]
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var hardHighscore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedData = defaults.object(forKey: "dataz") as? Data{
            if let decoded = try? JSONDecoder().decode([Int].self, from: savedData){
                print("dec\(decoded)")
                highscore = decoded
            }
        }
        hardHighscore.text = "Highscore: \(highscore[0])"
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
