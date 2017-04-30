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
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshop) in
            //print(snapshop.value ?? "posts_null") // return all data in same object
            self.posts = [] // THIS IS THE NEW LINE
            if let snapshops = snapshop.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshops {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostTableViewCell {
            cell.configureCell(post: post)
            return cell
        } else {
            return PostTableViewCell()
        }
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
