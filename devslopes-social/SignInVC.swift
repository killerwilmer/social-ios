//
//  ViewController.swift
//  devslopes-social
//
//  Created by Wilmer Arteaga on 21/04/17.
//  Copyright © 2017 tinpu. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var pwdField: FancyField!

    override func viewDidLoad() { //When load
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) { //When appear
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("Killer: Id Found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            print("Killer: Fail Auto sign in with keychain")
        }
    }

    @IBAction func facebookBtnTapped(_ sender: Any) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Killer: Unable to authenticate with Facebook - \(error)")
            } else if result?.isCancelled == true {
                print("Killer: User cancelled Facebook authentication")
            } else {
                print("Killer: Successfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Killer: Unable to authenticate with Firebase - \(error)")
            } else {
                print("Killer: Successfully authenticated with Firebase")
                if let user = user {
                    self.completeSignIn(id: user.uid)
                }
            }
        })
    }

    @IBAction func signInTapped(_ sender: Any) {
        
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("Killer: Email user authenticate with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Killer: Unable to authenticate to Firebase using email")
                        } else {
                            print("Killer: Successfully authenticate with Firebase")
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func completeSignIn(id: String) {
        let saveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        if saveSuccessful == true {
            print("Killer: KeychainWrapper save successfully")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        } else {
            print("Killer: Unable to save KeychainWrapper ")
        }
    }
}

