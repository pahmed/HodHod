//
//  ReportLostPersonViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ReportLostPersonViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!

    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    lazy var picker: UIImagePickerController = {
        let object = UIImagePickerController()
        object.delegate = self
        return object
    }()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            pickImageButton.isHidden = (image != nil)
        }
    }
    
    // firebase
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func takePhotoAction(_ sender: Any) {
        showimagePicker()
    }
    
    @IBAction func reportAction(_ sender: Any) {
        
        let info: [String: Any] = [
            "reporterID": "ali",
            "personID": "1122",
            "date": Date().timeIntervalSince1970,
            "personName": "ibrahim",
        ]
        
        ref.child("reports/lostPersons/case2/").setValue(info)
    }
    
    // MARK: image picker
    
    func showimagePicker() {
        let alert = UIAlertController(title: NSLocalizedString("Select image", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default) { [weak self] (_) in
            self?.showImagePicker(from: .camera)
        }
        
//        let delete = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .default) { (_) in
//
//        }
        
        let lib = UIAlertAction(title: NSLocalizedString("Photo Library", comment: ""), style: .default) { [weak self] (_) in
            self?.showImagePicker(from: .photoLibrary)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel)
        
        alert.addAction(camera)
        alert.addAction(lib)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }

    func showImagePicker(from source: UIImagePickerControllerSourceType) {
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }

    // MARK: - picker delegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
}
