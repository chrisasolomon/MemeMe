//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Chris Solomon on 2018-11-15.
//  Copyright © 2018 Chris Solomon. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textField.text = ""
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.resignFirstResponder()
	}

}
