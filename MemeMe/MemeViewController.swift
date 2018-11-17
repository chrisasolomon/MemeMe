//
//  ViewController.swift
//  MemeMe
//
//  Created by Chris Solomon on 2018-11-15.
//  Copyright © 2018 Chris Solomon. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var memeImageView: UIImageView!
	
	@IBOutlet weak var topToolBar: UIToolbar!
	@IBOutlet weak var shareButton: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	
	
	@IBOutlet weak var imagePickerToolbar: UIToolbar!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	
	let textFieldDelegate = MemeTextFieldDelegate()
	
	struct Meme {
		var topText: String
		var bottomText: String
		var originalImage: UIImage
		var memedImage: UIImage
	}
	
	// Lifecycle functions
	override func viewDidLoad() {
		super.viewDidLoad()
		
		prepareTextField(textField: topTextField, placeHolder: "TOP")
		prepareTextField(textField: bottomTextField, placeHolder: "BOTTOM")
		// TODO: clear text selectively - add a flag to textfield
//		topTextField.clearsOnBeginEditing = true
	}

	override func viewWillAppear(_ animated: Bool) {
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		
		//TODO: Enable/disable Action, Cancel buttons, textfields
		
		shareButton.isEnabled = (memeImageView.image != nil)
		
		subscribeToKeyboardNotifications()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		unsubscribeFromKeyboardNotifications()
	}
	
	// Actions
	
	@IBAction func pickImage(_ sender: Any) {
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		if sender as? UIBarButtonItem == albumButton {
			imagePicker.sourceType = .photoLibrary
		} else {
			imagePicker.sourceType = .camera
		}
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func shareAction(_ sender: Any) {
		let image = generateMemedImage()
		
		let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
		
		// TODO:
//		activity.completionWithItemsHandler = { , completed , items , error in
		present(activity, animated: true, completion: nil)
		
//		dismiss(animated: true, completion: nil)
	}
	
	
	// perhaps add this to TextView extension
	
	func prepareTextField(textField: UITextField, placeHolder: String) {
		let textAttributes: [NSAttributedString.Key:Any] = [
			NSAttributedString.Key.strokeColor: UIColor.black,
//			NSAttributedString.Key.strokeWidth: 5.0,
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
		]

		
		textField.delegate = textFieldDelegate
		
		textField.defaultTextAttributes = textAttributes
		
		textField.text = placeHolder
		textField.textAlignment = .center
	
		
	}
	
		func save(memedImage: UIImage) {
		let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memedImage: memedImage)
	}
	
	func generateMemedImage() -> UIImage {
		// TODO: Hide toolbar and navbar
		topToolBar.alpha = 0
		
		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		// TODO: Show toolbar and navbar
		topToolBar.alpha = 1
		
		return memedImage
	}
	
	// UIImagePickerDelegate Methods
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			memeImageView.image = image
		}
		dismiss(animated: true, completion: nil)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}
	
	// Keyboard accomodations
	@objc func keyboardWillShow(_ notification: Notification) {
		// adjust view if Bottom Textfield is in use .isEditing()
		
		view.frame.origin.y -= getKeyboardHeight(notification)
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		
		view.frame.origin.y = 0 //-= getKeyboardHeight(notification)
	}

	func getKeyboardHeight(_ notification:Notification) -> CGFloat {

		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
		return keyboardSize.cgRectValue.height
	}
	
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
}

