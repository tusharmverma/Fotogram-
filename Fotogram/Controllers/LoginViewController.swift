//
//  File.swift
//  Fotogram
//
//  Created by Tushar  Verma on 7/11/18.
//  Copyright © 2018 Tushar Verma. All rights reserved.
//

import Foundation
import UIKit
import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User
class LoginViewController: UIViewController{
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let authUI = FUIAuth.defaultAuthUI()
            else { return }
            // 2 we set our LoginViewController to be a delegate of authUI
            authUI.delegate = self
        // 3
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
}


extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let error = error {
            assertionFailure("Error signing in: \(error.localizedDescription)")
            return
        }
    
        // 1 First we check that the FIRUser returned from authentication is not nil by unwrapping it. We guard this statement, because we cannot proceed further if the user is nil. We need the FIRUser object's uid property to build the relative path for the user at /users/#{uid}.
        guard let user = authDataResult?.user
            else { return }
    
        // 2 We construct a relative path to the reference of the user's information in our database.
        
        let userRef = Database.database().reference().child("users").child(user.uid)
            
            // 3 We read from the path we created and pass an event closure to handle the data (snapshot) that is passed back from the database.
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // 1 To retrieve the user data from DataSnapshot, we check that the snapshot exists, and that it is of the expected Dictionary type. Based on whether the user dictionary exists, we'll know whether the current user is a new or returning user.
                if let userDict = snapshot.value as? [String : Any] {
                    print("User already exists \(userDict.debugDescription).")
                } else {
                    print("New user!")
                }
            })
        
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            if let user = User(snapshot: snapshot) {
                User.setCurrent(user, writeToUserDefaults: true)
                
                let storyboard = UIStoryboard(name: "Main", bundle: .main)
                if let initialViewController = storyboard.instantiateInitialViewController() {
                    self.view.window?.rootViewController = initialViewController
                }
            } else {
                // 1
                self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
            }
        })
    
    }
    
    

}



