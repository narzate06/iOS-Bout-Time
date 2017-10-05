//
//  ViewController.swift
//  Bout-Time
//
//  Created by Noe Arzate on 3/28/17.
//  Copyright © 2017 Noe Arzate. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet var factLabel1: UILabel!
    @IBOutlet var factLabel2: UILabel!
    @IBOutlet var factLabel3: UILabel!
    @IBOutlet var factLabel4: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var shakeButton: UIButton!
    @IBOutlet var nextRoundButton: UIButton!
    
    
    
    
    let dictionaryOfFacts: FactsRounds
    var fourRandomFacts: [FactContent]
    var timer = Timer()
    var counter = 0
    var roundTracking = GameRound()
    
    required init?(coder aDecoder: NSCoder) {
        do {
            let dictionary = try Plistconverter.dictionary(fromFile: "facts", ofType: "plist")
            let inventory = try FactDataUnarchiver.factData(fromDictionary: dictionary)
            self.dictionaryOfFacts = Rounds(factDictionary: inventory)
            self.fourRandomFacts = []
        } catch let error {
            fatalError("\(error)")
        }
        super.init(coder: aDecoder)
    }
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayRound()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func displayRound() {
        
        if roundTracking.completed >= roundTracking.totalRounds {
            
            //End game & show score
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultsController") as! ResultsController
            
            secondViewController.score = roundTracking.correct
            secondViewController.numberOfRounds = roundTracking.totalRounds
            self.present(secondViewController, animated: true, completion: nil)
            
        } else {
            nextRoundButton.isHidden = true
            // Four random facts
            fourRandomFacts = dictionaryOfFacts.nextRound()
            factLabel1.text = "\(fourRandomFacts[0].fact)"
            factLabel2.text = "\(fourRandomFacts[1].fact)"
            factLabel3.text = "\(fourRandomFacts[2].fact)"
            factLabel4.text = "\(fourRandomFacts[3].fact)"
            
            shakeButton.isHidden = false
            
            // Show counter
            timerLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 50.0, weight: UIFontWeightRegular)
            timerLabel.isHidden = false
            timerLabel.text = "0:00"
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            
        }
    }
    
    //Check round - score
    func checkRound(check answwer: Bool) {
        timerLabel.isHidden = true
        timer.invalidate()
        counter = 0
        
        shakeButton.isHidden = true
        roundTracking.completed += 1
        if answwer == true {
            roundTracking.correct += 1
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_success"), for: UIControlState.normal)
            nextRoundButton.isHidden = false
        } else {
            nextRoundButton.setImage(#imageLiteral(resourceName: "next_round_fail"), for: UIControlState.normal)
            nextRoundButton.isHidden = false
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake && timer.isValid == true {
            let answer = dictionaryOfFacts.checkRound(orderOfQuestions: fourRandomFacts)
            checkRound(check: answer)
        }
    }
    
    
    @IBAction func box1DownArrow() {
        rearrangeRound(fromIndex: 0, toIndex: 1)
    }
    
    @IBAction func box2UpArrow() {
        rearrangeRound(fromIndex: 1, toIndex: 0)
    }
    
    @IBAction func box2DownArrow() {
        rearrangeRound(fromIndex: 1, toIndex: 2)
    }
    
    @IBAction func box3UpArrow() {
        rearrangeRound(fromIndex: 2, toIndex: 1)
    }
    
    @IBAction func box3DownArrow() {
        rearrangeRound(fromIndex: 2, toIndex: 3)
    }
    
    @IBAction func box4UpArrow() {
        rearrangeRound(fromIndex: 3, toIndex: 2)
    }
    
    @IBAction func shakeToCompleteButton() {
        let answer = dictionaryOfFacts.checkRound(orderOfQuestions: fourRandomFacts)
        checkRound(check: answer)
    }
    
    @IBAction func nextRound() {
        displayRound()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        roundTracking.completed = 0
        roundTracking.correct = 0
        displayRound()
    }
    
    func rearrangeRound(fromIndex: Int, toIndex: Int) {
        swap(&fourRandomFacts[fromIndex], &fourRandomFacts[toIndex])
        
        factLabel1.text = "\(fourRandomFacts[0].fact)"
        factLabel2.text = "\(fourRandomFacts[1].fact)"
        factLabel3.text = "\(fourRandomFacts[2].fact)"
        factLabel4.text = "\(fourRandomFacts[3].fact)"
    }
    
    
    
    func updateTimer() {
        if counter >= 60 {
            timer.invalidate()
            let answer = dictionaryOfFacts.checkRound(orderOfQuestions: fourRandomFacts)
            checkRound(check: answer)
        } else {
            counter += 1
            timerLabel.text = timeString(time: TimeInterval(counter))
        }
    }
    
    
    func timeString(time: TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        return String(format:"%01i:%02i", minutes, seconds)
    }
}












































