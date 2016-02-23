//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Stu Almeleh on 2/3/16.
//  Copyright © 2016 Stu Almeleh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugTextLabel: UILabel!
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    
    
    var appDelegate: AppDelegate!
    var session: NSURLSession!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    /* Based on student comments, this was added to help with smaller resolution devices */
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
    
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
        loadingWheel.hidesWhenStopped = true

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
        
        loadingWheel.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailTextField {
            self.passwordTextField.becomeFirstResponder()
        }
        if textField == self.passwordTextField {
                loginButtonPressed(UIButton)
        }
        
        return true
    }
    
    
    /* shows alert view with error */
    func launchAlertController(error: String) {
        let alertController = UIAlertController(title: "", message: error, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .Default) { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        
        }
    }
    
    
    
    
    
    
    // MARK: Login
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if emailTextField.text!.isEmpty {
            launchAlertController("Username field is empty")
        } else if passwordTextField.text!.isEmpty {
            launchAlertController("Password field is empty")
        } else {
        
            loginButton.hidden = true
        
            //start loading animation
            loadingWheel.hidden = false
            loadingWheel.startAnimating()
        
            //begin POST session
            UdacityClient.sharedInstance().postASession(emailTextField.text!, password: passwordTextField.text!, completionHandler: handlerForLogin)
        }
    }
    
    
    func handlerForLogin(success: Bool, error: String) -> Void {
        if success {
            completeLogin()
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                self.loadingWheel.stopAnimating()
                self.loginButton.hidden = false
                self.launchAlertController(error)
            })
        }
    }
    
    
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            //stop loading animation
            self.loadingWheel.stopAnimating()
            
//            //success
//            print("succesfully logged in. sessionID: \(sessionID)")
//            UdacityClient.sharedInstance().sessionID = sessionID
            
            //complete login
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
        })
    }

    
    
    
    
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

}


