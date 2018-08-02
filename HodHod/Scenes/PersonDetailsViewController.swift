//
//  PersonDetailsViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit

class PersonDetailsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!

    var person: Person!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindPersonModelToView()
    }
    
    func bindPersonModelToView() {
        nameTextField.text = person.name
        idTextField.text = person.personID
        imageView.image = person.image()
//        notesTextField.text = 
    }
    
}
