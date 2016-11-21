//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Lloyd Luck on 11/20/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit
import LocalAuthentication

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!

    var authenticationLabel: UILabel?
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Perform custom UI setup here
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.view.addSubview(self.nextKeyboardButton)
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true

        setupKeyboardForAuthentication()

    }

    func setupKeyboardForAuthentication() {
        let authenticationTopRow = addAuthenticationTopRow()


    }

    func addKeyboardRow(titles: [String], below: UIView) -> UIView {
        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        let buttons = createButtons(titles: titles)
        
    }

    func addAuthenticationTopRow() -> UIView {
        let passwordTextField = UILabel()
        authenticationLabel = passwordTextField
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.backgroundColor = UIColor.yellow
        let submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setContentHuggingPriority(1000, for: .horizontal)
        submitButton.backgroundColor = UIColor.blue
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(passwordTextField)
        topView.addSubview(submitButton)

        passwordTextField.leftAnchor.constraint(equalTo: topView.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: submitButton.leftAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: topView.topAnchor).isActive = true
        submitButton.rightAnchor.constraint(equalTo: topView.rightAnchor).isActive = true
        submitButton.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true

        view.addSubview(topView)
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true

        return topView
    }


    /// Sadly this does not work in the extension
    func authenticateWithTouchID() {
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
                }
            })

        } else {
            // Probably should do some other form of authentication or tell the user to switch keyboards
        }
    }

    func updateKeyboardAfterAuthentication() {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
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
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    func didPressAuthenticationKeyboardButton(_ button: UIButton) {
        guard let title = button.title(for: .normal) else { return }
        if title != "BS" {
            var passwordText = authenticationLabel?.text ?? ""
            passwordText += title
            authenticationLabel?.text = passwordText
        } else if var passwordText = authenticationLabel?.text, !passwordText.isEmpty {
            passwordText.characters.removeLast()
            authenticationLabel?.text = passwordText
        }
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
