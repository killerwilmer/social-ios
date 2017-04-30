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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshop) in
            print(snapshop.value ?? "posts_null")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
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
