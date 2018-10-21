//
//  LoginPageViewController.swift
//  LansWallet
//
//  Created by ruolan zeng on 10/7/18.
//  Copyright © 2018 ruolan zeng. All rights reserved.
//

import UIKit

import libPhoneNumber_iOS

class LoginPageViewController: UIViewController, UITextFieldDelegate
{
    
    let variable = NBPhoneNumberUtil()
    var phoneNumberTyping = NBAsYouTypeFormatter.init(regionCode: "US")

    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var errorMessage: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var phoneNumberToPass = String()
    @IBAction func sendMessage(_ sender: UIButton) {
        let phoneUtil = NBPhoneNumberUtil()
        self.errorMessage.text = ""
        
        do {
            if phoneUtil.isValidNumber(try phoneUtil.parse(self.phoneNumber.text!, defaultRegion: "US")) == true{
                let phoneNumberTyped: NBPhoneNumber = try phoneUtil.parse(self.phoneNumber.text!, defaultRegion: "US")

                let e164FormattedString: String = try phoneUtil.format(phoneNumberTyped, numberFormat: .E164)
                
                phoneNumberToPass = e164FormattedString
                
                Api.sendVerificationCode(phoneNumber: e164FormattedString){ response, error in
                    if error == nil{
                        self.performSegue(withIdentifier: "verificationPage", sender: sender)
                    }else{
                        self.errorMessage.text = "The phone number entered is not valid, please try again."
                    }
                    
                }
                
            }else{
                self.errorMessage.text = "The phone number entered is not valid, please try again."
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
            self.errorMessage.text = "The phone number entered cannot be empty, please try again."
        }
    }
    
    @IBAction func transform(_ sender: UITextField) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumber.delegate = self
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if !(string.count + range.location > 14) {
            //
            if string.isEmpty == false {
                textField.text = phoneNumberTyping?.inputDigit(string)
            }
            else {
                textField.text = phoneNumberTyping?.removeLastDigit()
            }
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let VerificationVC = segue.destination as! VerificationViewController
        VerificationVC.phoneNumberPassed = self.phoneNumberToPass
    }
}
