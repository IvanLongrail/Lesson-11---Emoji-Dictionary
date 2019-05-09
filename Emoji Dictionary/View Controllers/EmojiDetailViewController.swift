//
//  EmojiDetailViewController.swift
//  Emoji Dictionary
//
//  Created by Denis Bystruev on 11/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import UIKit

class EmojiDetailViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var symbolField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var usageField: UITextField!
    @IBOutlet weak var scrollViewBottomLayout: NSLayoutConstraint!
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    var emoji = Emoji()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
        super.viewWillDisappear(animated)
    }
    
    func areFieldsReady() -> Bool {
        return !symbolField.isEmpty && !nameField.isEmpty && !descriptionField.isEmpty && !usageField.isEmpty
    }
    
    func saveEmoji() {
        emoji.symbol = symbolField.text ?? ""
        emoji.name = nameField.text ?? ""
        emoji.description = descriptionField.text ?? ""
        emoji.usage = usageField.text ?? ""
    }
    
    func setupUI() {
        symbolField.delegate = self
        nameField.delegate = self
        descriptionField.delegate = self
        usageField.delegate = self
        
        symbolField.text = emoji.symbol
        nameField.text = emoji.name
        descriptionField.text = emoji.description
        usageField.text = emoji.usage
    }
    
    func updateUI() {
        if symbolField.text!.count > 1 {
            symbolField.text = String( symbolField.text!.first! )
        }
        saveButton.isEnabled = areFieldsReady()
    }
    
    @IBAction func textChanged() {
        updateUI()
    }
}

// MARK: - Navigation
extension EmojiDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        saveEmoji()
    }
}

// MARK: - UITextFieldDelegate
extension EmojiDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension EmojiDetailViewController {
    

    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollViewBottomLayout.constant = keyboardSize.height
            addTapRecognizer()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollViewBottomLayout.constant = 0
        removeTapRecognizer()
    }
    
    //dismiss keyboard by tap
    func addTapRecognizer() {
        if keyboardDismissTapGesture == nil {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            keyboardDismissTapGesture?.cancelsTouchesInView = false
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func removeTapRecognizer() {
        if keyboardDismissTapGesture != nil {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //        super.viewWillTransition(to: size, with: coordinator)
    //        let a = self.view.firstResponder!.frame.height
    //        let b = self.view.firstResponder!.frame.width
    //        let f = scrollViewBottomLayout.constant
    //        scrollViewBottomLayout.constant = self.view.firstResponder!.frame.height
    //    }
    
    //    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //    super.viewWillTransition(to: size, with: coordinator)
    //
//            if let currentTextField = self.view.firstResponder as? UITextField {
//
//                self.view.endEditing(true)
//
//                currentTextField.becomeFirstResponder()
    //
    //        }
    //
    //    }
    //}
    //
    //
    //
//    extension UIView {
//        var firstResponder: UIView? {
//            guard !isFirstResponder else { return self }
//
//            for subview in subviews {
//                if let firstResponder = subview.firstResponder {
//                    return firstResponder
//                }
//            }
//
//            return nil
//        }
//    }

    
}

