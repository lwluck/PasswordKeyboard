//
//  ViewController.swift
//  PasswordKeyboard
//
//  Created by Lloyd Luck on 11/20/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var displayLoginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var displayLabel: UILabel!

    @IBAction func didPressDisplayLogin(_ sender: UIButton) {
        guard let usernameText = usernameField.text,
            let passwordText = passwordField.text else
        {
            displayLabel.text = "Login Info Will Go Here"
            return
        }

        displayLabel.text = "Entered Login:\nUsername: \(usernameText)\nPassword: \(passwordText)"
    }

}

