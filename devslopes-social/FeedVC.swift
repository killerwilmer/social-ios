//
//  FeedVC.swift
//  devslopes-social
//
//  Created by Wilmer Arteaga on 27/04/17.
//  Copyright © 2017 tinpu. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        if removeSuccessful == true {
            print("Killer: ID removed from keychain \(removeSuccessful)")
        }
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil) //esto libera memoria
        //performSegue(withIdentifier: "goToSignIn", sender: nil) // va a sign in pero queda la vista cargada en memoria
    }
}
