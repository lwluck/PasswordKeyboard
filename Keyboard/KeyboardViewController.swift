//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Lloyd Luck on 11/20/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit
import LocalAuthentication

class KeyboardViewController: UIInputViewController, AuthenticationDelegate {

    var authenticationLabel: UILabel?

    var authenticationView: AuthenticationView?

    @IBOutlet var nextKeyboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateKeyboard()

    }

    func didPressNextKeyboard(_ sender: UIView) {
        advanceToNextInputMode()
    }

    func authenticationSuccessful() {
        print("Authentication Successful")
        updateKeyboardAfterAuthentication()
    }

    func setupKeyboardForAuthentication() {
        let nib = UINib(nibName: "AuthenticationView", bundle: nil)
        let objects = nib.instantiate(withOwner: self, options: nil)
        let authenticationView = objects[0] as! AuthenticationView
        self.authenticationView = authenticationView
        authenticationView.translatesAutoresizingMaskIntoConstraints = false
        authenticationView.delegate = self

        view.addSubview(authenticationView)

        authenticationView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        authenticationView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        authenticationView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        authenticationView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    func authenticateKeyboard() {
        let authContext: LAContext = LAContext()
        var error: NSError?

        //Is Touch ID hardware available & configured?
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            // Perform Touch ID Auth
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlocking Password Valut", reply: {[weak self] (successful, error) in
                if successful {
                    // User authenticated
                    self?.updateKeyboardAfterAuthentication()
                } else {
                    // Probably should do some other form of authentication or tell the user to switch keyboards
                    self?.setupKeyboardForAuthentication()
                }
            })

        } else {
            // Probably should do some other form of authentication or tell the user to switch keyboards
            setupKeyboardForAuthentication()
        }
    }

    func updateKeyboardAfterAuthentication() {
        authenticationView?.removeFromSuperview()

        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)

        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false

        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)

        self.view.addSubview(self.nextKeyboardButton)

        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true


        let defaults = UserDefaults(suiteName: "group.com.lwluck.passwordkeyboard")
        var buttons: [UIButton] = []
        if let logins = defaults?.dictionary(forKey: "logins") {
            let usernames: [String] = Array(logins.keys)
            buttons = createButtons(titles: usernames)
        }

        let firstButton = buttons.removeFirst()
        view.addSubview(firstButton)
        firstButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        firstButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        var currentTopView: UIView = firstButton
        for button in buttons {
            view.addSubview(button)
            button.topAnchor.constraint(equalTo: currentTopView.bottomAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            button.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            currentTopView = button
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
//        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    func didPressAuthenticationKeyboardButton(_ button: UIButton) {
        
    }
    
    func didPressKeyboardButton(_ button: UIButton) {
        guard let defaults = UserDefaults(suiteName: "group.com.lwluck.passwordkeyboard"),
            let logins = defaults.dictionary(forKey: "logins"),
            let username = button.title(for: .normal),
            let password = logins[username] as? String else
        {
            return
        }

        (textDocumentProxy as UIKeyInput).insertText(username)

        print("Username: \(username)")
        print("Password: \(password)")
        print("Saving password to pasteboard")
        print()
        
        let pasteboard = UIPasteboard.general
        pasteboard.string = password
    }
    
    func createButtons(titles: [String], selector: Selector = #selector(didPressKeyboardButton(_:))) -> [UIButton] {
        return titles.map { (title) -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.addTarget(self, action: selector, for: .touchUpInside)
            return button
        }
    }

}
