//
//  ViewController.swift
//  Apple Catch!
//
//  Created by Kevin Sheehy on 4/28/17.
//  Copyright © 2017 Kevin Sheehy. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

class ViewController: UIViewController {
    
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet weak var basket: UIImageView!
    @IBOutlet weak var apple: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score = 0
    var musicPlayer = AVAudioPlayer()
    var animator: UIDynamicAnimator!
    var gravity = UIGravityBehavior()
    let collider = UICollisionBehavior()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        //creates the gesture recognizer, you always use target as self; in the action we are just calling the function
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGesture:)))
        //this just adds the gesture recognizer to the basket
        self.basket.addGestureRecognizer(pan)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func handlePan(panGesture: UIPanGestureRecognizer) {
        if panGesture.state == .began || panGesture.state == .changed {
        //translation is how much they move from the previous psoition in *we said in the view*
        var translation = panGesture.translation(in: self.view)
        let newPosition = self.basket.frame.origin.x + translation.x
        if newPosition >= 0 && newPosition <= self.view.frame.width - self.basket.frame.width {
        self.basket.frame.origin.x = newPosition
        }
        //we set it to zero because the new location has to be zero or else the next time you move it it will still think you are at the previous location
        panGesture.setTranslation(CGPoint.zero, in: self.view)
        //detectCollision()
        } else {
            //detectCollision()
        }
    }
    
    func detectCollision() {
        let appleX = self.apple.center.x
        let basketX = self.basket.center.x
        let difference = abs(basketX - appleX)
        if difference < self.apple.frame.width && self.apple.frame.origin.y + self.apple.frame.height >= self.basket.frame.origin.y {
            collided()
        }
        
        if self.apple.frame.origin.y > self.view.frame.height + self.apple.frame.height {
                self.apple.frame.origin.y = -(self.apple.frame.size.height)
            endGame()
    }
}

    func collided() {
        resetApple()
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    
    @IBAction func beginButtonPressed(_ sender: Any) {
        beginButton.isHidden = true
        score = 0
        scoreLabel.text = "Score: 0"
        appleToBottom()
        playSound(soundName: "sound0")
        _ = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(detectCollision), userInfo: nil, repeats: true)
        }
    
    func resetApple() {
        self.apple.removeFromSuperview()
        let randomTopLocation = Int(arc4random_uniform(UInt32((view.frame.size.width - self.apple.frame.maxX))))
        self.apple.frame = CGRect(x: CGFloat(randomTopLocation), y: -40, width: 42, height: 40)
        self.view.addSubview(self.apple)
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        gravity.addItem(self.apple)
        var duration = 0.0
        if score < 10 {
            duration = 0.3
        } else if score >= 10 && score < 20 {
            duration = 0.45
        } else if score >= 20 && score < 30 {
            duration = 0.6
        } else if score >= 30 && score < 40 {
            duration = 0.75
        } else {
            duration = 0.9
        }

        let direction = CGVector(dx: 0.0, dy: duration)
        gravity.gravityDirection = direction
        animator.addBehavior(gravity)
        
        
    }
    
    func appleToBottom() {
        let randomTopLocation = Int(arc4random_uniform(UInt32((view.frame.size.width - self.apple.frame.maxX))))
        self.apple.frame.origin.x = CGFloat(randomTopLocation)
        animator = UIDynamicAnimator(referenceView: self.view)
        
        gravity.addItem(self.apple)
        let direction = CGVector(dx: 0.0, dy:0.3)
        gravity.gravityDirection = direction
        animator.addBehavior(gravity)
    }
    
    func endGame() {
        self.apple.removeFromSuperview()
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        beginButton.isHidden = false
        self.view.addSubview(self.apple)
    }
    
    func playSound(soundName: String) {
        if let sound = NSDataAsset(name: soundName) { //this grabs data out of a catalog (can be used for any type of data).  sound is actually sound.data, you just don't have to put .data
            do {
                try musicPlayer = AVAudioPlayer(data: sound.data)
                musicPlayer.play()
            }
            catch {
                print("ERROR: Data from \(soundName) could not be played as an audiofile")
            }
        } else {
            print("ERROR: Could not load data from file \(soundName)")
        }
        
        //what this function is saying: is there a file called sound0 --> if there is let's grab data out of it and assign it to a data type called sound
        
        }

    }
