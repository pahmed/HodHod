//
//  LoginViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import AVKit

class LoginViewController: UIViewController {

    @IBOutlet weak var organizationTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let org = organizationTextField.text ?? ""
        let id = idTextField.text ?? ""
        
        guard id.isEmpty == false && org.isEmpty == false else {
            Alert(title: "Credentials required", message: "")
                .addCancelAction(title: "Ok")
                .show(in: self)
            
            return false
        }
        
        let user = User(id: id, organization: org)
        Store.shared.currentUser = user
        
        return true
    }

}
