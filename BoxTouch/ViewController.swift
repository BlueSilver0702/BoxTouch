//
//  ViewController.swift
//  BoxTouch
//
//  Created by Blue Silver on 2/3/16.
//  Copyright © 2016 Blue Silver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordTxt: UITextField!
    @IBOutlet weak var boxView: UIView!
    
    var wordPicker: DownPicker!
    var wordSelected: Int!
    var leaveBoxCount: Int = 0
    var countSelected: Int = 0
    var wordList: NSArray! = ["big", "at", "for", "like", "look", "see", "where", "you"]
    var randomNumArray: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init Word Picker
        self.wordPicker = DownPicker()
        self.wordPicker = DownPicker(textField: self.wordTxt, withData:wordList as [AnyObject])
        self.wordPicker.setPlaceholder("Select word to find")
        self.wordPicker.addTarget(self, action: "wordDidSelected", forControlEvents: UIControlEvents.ValueChanged)
        
        // init UI state
        boxView.hidden = true
        wordTxt.hidden = false
    }
    
    /* call back func after word will be selected */
    func wordDidSelected() {
        if wordPicker.selectedIndex >= 0 {
            wordSelected = wordPicker.selectedIndex
            
            countSelected = Int(arc4random_uniform(UInt32(4)) + 1)
            while randomNumArray.count < countSelected {
                let rand = Int(arc4random_uniform(UInt32(8)))
                for(var ii = 0; ii < countSelected; ii++){
                    if randomNumArray.contains(rand){

                    } else {
                        randomNumArray.append(rand)
                    }
                }
            }
            
            showBox()
        }
    }
    
    // MARK: - Box UI Update

    /* show Boxes and hide Count Picker */
    func showBox() {
        addBox()
        UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.boxView.hidden = false
            self.wordTxt.hidden = true
        }, completion: { (finished: Bool) -> () in
        })
    }
    
    /* hide Boxes and show Count Picker */
    func hideBox() {
        wordTxt.text = ""
        randomNumArray = []
        UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.boxView.hidden = true
            self.wordTxt.hidden = false
        }, completion: { (finished: Bool) -> () in
        })
    }
    
    /* add Boxes on Screen */
    func addBox() {
        self.boxView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        leaveBoxCount = countSelected
        
        let btnWidth: CGFloat = 320 * 0.75 / CGFloat(countSelected)
        let btnHeight: CGFloat = 54.0
        let btnLeft: CGFloat = 320 * 0.25 / CGFloat(countSelected + 1)
        
        for var i: Int = 0; i < countSelected; i++ {
            let boxBtn:UIButton = UIButton(frame: CGRectMake(btnWidth * CGFloat(i) + btnLeft * CGFloat(i + 1), 0, btnWidth, btnHeight))
            boxBtn.setBackgroundImage(UIImage(named: "Image") as UIImage?, forState: UIControlState.Normal)
            let wordIndex:Int = randomNumArray[i]
            boxBtn.setTitle(wordList[wordIndex] as? String, forState: UIControlState.Normal)
            boxBtn.addTarget(self, action: "removeBox:", forControlEvents: UIControlEvents.TouchUpInside)
            boxBtn.tag = wordIndex;
            self.boxView.addSubview(boxBtn)
        }
    }
    
    /* remove Boxes whenever btn clicked */
    func removeBox(sender: UIButton) {
        if sender.tag == wordSelected {
            hideBox()
        } else {
            sender.removeFromSuperview()
            self.leaveBoxCount--
            
            // show Count Picker if all Boxes removed
            if self.leaveBoxCount == 0 {
                hideBox()
            }
            
            // update Boxes frame once removed one Box touched
            let btnWidth: CGFloat = 320 * 0.75 / CGFloat(countSelected)
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

