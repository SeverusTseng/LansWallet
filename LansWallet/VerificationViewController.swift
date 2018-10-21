//
//  VerificationViewController.swift
//  LansWallet
//
//  Created by ruolan zeng on 10/20/18.
//  Copyright © 2018 ruolan zeng. All rights reserved.
//

import Foundation
import UIKit

class VerificationViewController: UIViewController, UITextFieldDelegate
{
    var phoneNumberPassed = String()
    
    @IBOutlet weak var VerificationCodeText: UITextField!
    @IBOutlet weak var invalidCodeMessage: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @IBAction func VerifyCode(_ sender: UIButton) {
        Api.verifyCode(phoneNumber: phoneNumberPassed, code: VerificationCodeText.text!){ response, error in
            if error != nil{
                self.invalidCodeMessage.text = error?.message
                self.resendCodeButton.isHidden = false
            }else{
                self.invalidCodeMessage.text = "verified"
            }
        }
    }
    
    @IBAction func ResendCode(_ sender: UIButton) {
        Api.sendVerificationCode(phoneNumber: phoneNumberPassed){ response, error in
            if error != nil{
                self.invalidCodeMessage.text = error?.message
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resendCodeButton.isHidden = true
        VerificationCodeText.delegate = self
    }
}
