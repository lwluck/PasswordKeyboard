//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Lloyd Luck on 11/20/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
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
    
    func buttonPressed(button: UIButton) {
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
    
    func createButtons(titles: [String]) -> [UIButton] {
        return titles.map { (title) -> UIButton in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.addTarget(self, action: #selector(buttonPressed(button:)), for: .touchUpInside)
            return button
        }
    }

}
