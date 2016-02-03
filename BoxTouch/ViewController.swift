//
//  ViewController.swift
//  BoxTouch
//
//  Created by Blue Silver on 2/3/16.
//  Copyright © 2016 Blue Silver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var countTxt: UITextField!
    @IBOutlet weak var boxView: UIView!
    
    var downPicker: DownPicker!
    var countSelected: Int!
    var leaveBoxCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init Count Picker
        self.downPicker = DownPicker()
        let persons: NSMutableArray = ["1", "2", "3", "4", "5"]
        self.downPicker = DownPicker(textField: self.countTxt, withData:persons as [AnyObject])
        self.downPicker.setPlaceholder("Select Box Count")
        self.downPicker.addTarget(self, action: "countDidSelected", forControlEvents: UIControlEvents.ValueChanged)
        
        // init UI state
        self.boxView.hidden = true
        self.countTxt.hidden = false
    }

    func countDidSelected() {
        countSelected = Int(downPicker.getTextField().text!)
        if countSelected > 0 {
            self.showBox()
        }
    }
    
    // MARK: - Box UI Update
    
    /* show Boxes and hide Count Picker */
    func showBox() {
        addBox()
        UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.boxView.hidden = false
            self.countTxt.hidden = true
            self.downPicker.hidden = true
        }, completion: { (finished: Bool) -> () in
        })
    }
    
    /* hide Boxes and show Count Picker */
    func hideBox() {
        self.countTxt.text = ""
        UIView.transitionWithView(self.view, duration: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.boxView.hidden = true
            self.countTxt.hidden = false
            self.downPicker.hidden = false
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
            boxBtn.setTitle(String(format: "Box%d", i), forState: UIControlState.Normal)
            boxBtn.addTarget(self, action: "removeBox:", forControlEvents: UIControlEvents.TouchUpInside)
            boxBtn.tag = i;
            self.boxView.addSubview(boxBtn)
        }
    }
    
    /* remove Boxes whenever btn clicked */
    func removeBox(sender: UIButton) {
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

