//
//  AuthenticationView.swift
//  PasswordKeyboard
//
//  Created by Lloyd Luck on 11/21/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit

protocol AuthenticationDelegate: class {
    func authenticationSuccessful()
    func didPressNextKeyboard(_ sender: UIView)
}

class AuthenticationView: UIView, KeyboardDelegate {

    @IBOutlet weak var keyboardContainerView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!

    weak var delegate: AuthenticationDelegate?

    override func layoutSubviews() {
        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        let keyboardView = objects[0] as! UIView
        keyboardView.translatesAutoresizingMaskIntoConstraints = false

        keyboardContainerView.addSubview(keyboardView)
        keyboardView.topAnchor.constraint(equalTo: keyboardContainerView.topAnchor).isActive = true
        keyboardView.leftAnchor.constraint(equalTo: keyboardContainerView.leftAnchor).isActive = true
        keyboardView.rightAnchor.constraint(equalTo: keyboardContainerView.rightAnchor).isActive = true
        keyboardView.bottomAnchor.constraint(equalTo: keyboardContainerView.bottomAnchor).isActive = true

        super.layoutSubviews()
    }


    func didPressKeyboardButton(_ sender: UIButton) {
        guard let title = sender.title(for: .normal) else { return }
        let characterToAdd = title.contains("Space") ? " " : title
        var passwordText = passwordLabel.text ?? ""
        passwordText += characterToAdd
        passwordLabel.text = passwordText
    }

    func didPressBackSpace(_ sender: UIButton) {
        guard var passwordText = passwordLabel.text, !passwordText.isEmpty else { return }
        passwordText.characters.removeLast()
        passwordLabel.text = passwordText
    }

    func didPressNextKeyboard(_ sender: UIButton) {
        delegate?.didPressNextKeyboard(sender)
    }

    @IBAction func didPressSubmit(_ sender: UIButton) {
        if passwordLabel.text == "PASSWORD" {
            delegate?.authenticationSuccessful()
        }
    }
}
