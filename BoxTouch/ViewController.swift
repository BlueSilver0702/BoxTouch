//
//  ViewController.swift
//  BoxTouch
//
//  Created by Blue Silver on 2/3/16.
//  Copyright © 2016 Blue Silver. All rights reserved.
//

import UIKit

extension Array
{
    /** Randomizes the order of an array's elements. */
    mutating func shuffle(arrayCount: Int)
    {
        for _ in 0..<arrayCount + 1
        {
            sortInPlace { (_,_) in arc4random() < arc4random() }
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var boxView: UIView!
    @IBOutlet weak var currentLab: UILabel!

    var wordList: NSArray! = ["big", "at", "for", "like", "look", "see", "where", "you"]
    var leaveBoxCount: Int = 0
    var wordSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // start game once loaded
        newRound()
    }
 
    // MARK: - Game API
    
    /* get random answer object index */
    func getRandomWord(wordList: NSArray) -> Int {
        return Int(arc4random_uniform(UInt32(wordList.count)))
    }
    
    /* get random count to select subarray */
    func getNumberOfChoices() -> Int {
        return Int(arc4random_uniform(UInt32(4)) + 1)
    }
    
    /* get random subarray */
    func getChoices(wordList: NSArray, numWordsToGet: Int, currentWord: Int) -> [Int] {
        var randomNumArray: [Int] = [currentWord]
        
        while randomNumArray.count < numWordsToGet {
            let rand = getRandomWord(wordList)
            if !randomNumArray.contains(rand){
                randomNumArray.append(rand)
            }
        }
        
        randomNumArray.shuffle(randomNumArray.count)
        
        return randomNumArray
    }
    
    // MARK: - Box UI Update

    /* main round flow */
    func newRound() {
        
        let wordToFind: Int! = getRandomWord(wordList)
        let numberOfChoices: Int! = getNumberOfChoices()
        let wordsToShow: [Int]! = getChoices(wordList, numWordsToGet: numberOfChoices, currentWord: wordToFind)

        addBox(wordsToShow, wordToFind: wordToFind)
    }
    
    /* add Boxes on Screen */
    func addBox(wordsToShow: [Int], wordToFind: Int) {
        self.boxView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        leaveBoxCount = wordsToShow.count
        wordSelected = wordToFind
        currentLab.text = wordList[wordSelected] as? String
        
        let btnWidth: CGFloat = 320 * 0.75 / CGFloat(wordsToShow.count)
        let btnHeight: CGFloat = 54.0
        let btnLeft: CGFloat = 320 * 0.25 / CGFloat(wordsToShow.count + 1)
        
        for var i: Int = 0; i < wordsToShow.count; i++ {
            let boxBtn:UIButton = UIButton(frame: CGRectMake(btnWidth * CGFloat(i) + btnLeft * CGFloat(i + 1), 0, btnWidth, btnHeight))
            boxBtn.setBackgroundImage(UIImage(named: "Image") as UIImage?, forState: UIControlState.Normal)
            let wordIndex:Int = wordsToShow[i]
            boxBtn.setTitle(wordList[wordIndex] as? String, forState: UIControlState.Normal)
            boxBtn.addTarget(self, action: "removeBox:", forControlEvents: UIControlEvents.TouchUpInside)
            boxBtn.tag = wordIndex;
            self.boxView.addSubview(boxBtn)
        }
    }
    
    /* remove Boxes whenever btn clicked */
    func removeBox(sender: UIButton) {
        if sender.tag == wordSelected {
            UIAlertView(title: "New round, choose a word", message: nil, delegate: nil, cancelButtonTitle: "Start").show()
            newRound()
        } else {
            sender.removeFromSuperview()
            self.leaveBoxCount--
            
            // show Count Picker if all Boxes removed
            if self.leaveBoxCount == 0 {
                newRound()
            }
            
            // update Boxes frame once removed one Box touched
            let btnWidth: CGFloat = self.boxView.subviews[0].frame.size.width
            let btnHeight: CGFloat = 54.0
            
            UIView.transitionWithView(self.view, duration: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                for var i: Int = 0; i < self.leaveBoxCount; i++ {
                    let btnLeft: CGFloat = (320 - btnWidth * CGFloat(self.leaveBoxCount)) / CGFloat(self.leaveBoxCount + 1)
                    let boxBtn:UIButton = self.boxView.subviews[i] as! UIButton
                    boxBtn.frame = CGRectMake(btnWidth * CGFloat(i) + btnLeft * CGFloat(i + 1), 0, btnWidth, btnHeight)
                }
                }, completion: { (finished: Bool) -> () in
            })
        }
    }
}

