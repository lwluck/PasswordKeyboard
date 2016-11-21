//
//  KeyboardView.swift
//  PasswordKeyboard
//
//  Created by Lloyd Luck on 11/21/16.
//  Copyright © 2016 Lloyd Luck. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func didPressKeyboardButton(_ sender: UIButton)
    func didPressBackSpace(_ sender: UIButton)
    func didPressNextKeyboard(_ sender: UIButton)
}

class KeyboardView: UIView {

    weak var delegate: KeyboardDelegate?
    
    @IBAction func didPressKeyboardButton(_ sender: UIButton) {
        delegate?.didPressKeyboardButton(sender)
    }

    @IBAction func didPressBackSpace(_ sender: UIButton) {
        delegate?.didPressBackSpace(sender)
    }

    @IBAction func didPressNextKeyboard(_ sender: UIButton) {
        delegate?.didPressNextKeyboard(sender)
    }


}
