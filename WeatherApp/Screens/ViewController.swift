//
//  ViewController.swift
//  WeatherApp
//
//  Created by Puru on 29/06/20.
//  Copyright © 2020 Purushottam Chandra. All rights reserved.
//

import UIKit
import GoogleSignIn
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField! {
        didSet {
            emailTextfield.delegate = self
        }
    }
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var passwordTextfield: UITextField! {
        didSet {
            passwordTextfield.delegate = self
        }
    }
    @IBOutlet var passwordErrorLabel: UILabel!
    
    @IBOutlet var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 5
            loginButton.addTarget(self, action: #selector(loginDidTapped), for: .touchUpInside)
        }
    }
    @IBOutlet weak var signInButton: GIDSignInButton! {
        didSet {
            signInButton.colorScheme = .dark
            signInButton.style = .wide
        }
    }
    @IBOutlet var loginBiometricButton: UIButton! {
        didSet {
            loginBiometricButton.addTarget(self, action: #selector(biomatricLogin), for: .touchUpInside)
        }
    }
    
    var loginCompletion: (()->Void)? = nil
    private let localAuthenticationContext = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self        
    }

    @objc func loginDidTapped() {
        view.endEditing(true)
        if emailTextfield.text?.isEmpty == true {
            emailErrorLabel.alpha = 1
            
            if passwordTextfield.text?.isEmpty == true {
                passwordErrorLabel.alpha = 1
            }
            return
        } else {
            let _ = checkEmailValidation()
        }
        
        if passwordTextfield.text?.isEmpty == true {
            passwordErrorLabel.alpha = 1
            return
        }
        passwordErrorLabel.alpha = 0

        loginCompletion?()
    }
    
    @objc func biomatricLogin() {
        loginWithBiomatric()
    }
    
    private func loginWithBiomatric() {
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To login to the app"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    DispatchQueue.main.async {
                        self.loginCompletion?()
                    }
                } else {
                    let alert = UIAlertController(title: "Authentication Failed!", message: "Something seems to have gone wrong. Please try again later.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }

                }
            }
        } else {
            let alert = UIAlertController(title: "No Biomatric Data Enrolled!", message: "Sorry, but you cannot proceed with this option without enrolling your Biomatric Data with your iPhone.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler: nil))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }

    func checkEmailValidation() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: emailTextfield.text ?? "") {
            emailErrorLabel.alpha = 1
            return false
        }
        emailErrorLabel.alpha = 0
        return true
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            if checkEmailValidation() {
                passwordTextfield.becomeFirstResponder()
            }
        } else if textField == passwordTextfield {
            loginDidTapped()
        }
        return true
    }
}
