//
//  ViewController.swift
//  MemeMe
//
//  Created by soheiln on 4/27/16.
//  Copyright © 2016 soheiln. All rights reserved.
//

import UIKit
import Darwin

class MemeEditorViewController: UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UITextFieldDelegate {

    
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var imagePicker: UIImagePickerController!
    var memedImage: UIImage!
    var meme: Meme!
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
        init(topText_: String, bottomText_: String, originalImage_: UIImage, memedImage_: UIImage) {
            topText = topText_
            bottomText = bottomText_
            originalImage = originalImage_
            memedImage = memedImage_
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        print("image size: " + String(imageView.image?.size.width) + "," + String(imageView.image?.size.height))
        imageView.clipsToBounds = true
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        setTextFieldStyle(topText, defaultText: "TOP")
        setTextFieldStyle(bottomText, defaultText: "BOTTOM")
        
        shareButton.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()

    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotification()
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        setTextFieldStyle(topText, defaultText: "TOP")
        setTextFieldStyle(bottomText, defaultText: "BOTTOM")
        imageView.image = nil
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if sender as! NSObject == cameraButton {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        } else {
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, error: NSError?) in
            if (completed) {
                self.saveMeme()
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navbar
        navigationBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }

    func setTextFieldStyle(textField: UITextField, defaultText: String) {
        textField.delegate = self
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = NSTextAlignment.Center
        textField.text = defaultText
    }
    
    func saveMeme() {
        // Create the meme
        meme = Meme(topText_: topText.text!, bottomText_: bottomText.text!, originalImage_: imageView.image!, memedImage_: memedImage)
    }
    
    // MARK: ImagePickerControllerDelegate Implementations
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
        shareButton.enabled = true
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate Implementations
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Keyboard Notification Subscription
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = getKeyboardHeight(notification) * -1
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

}

