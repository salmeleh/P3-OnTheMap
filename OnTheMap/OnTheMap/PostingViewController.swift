//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit

class PostingViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    @IBOutlet weak var linkTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        labelOne.hidden = false
        labelTwo.hidden = false
        labelThree.hidden = false
        findButton.hidden = false
        locationTextField.hidden = false
        submitButton.hidden = true
        linkTextField.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func findButtonPressed(sender: AnyObject) {
        labelOne.hidden = true
        labelTwo.hidden = true
        labelThree.hidden = true
        findButton.hidden = true
        locationTextField.hidden = true
        submitButton.hidden = false
        linkTextField.hidden = false
    }
    
    
    //@IBAction func submitButtonPressed(sender: AnyObject) {
    //}
    
    
    
}

