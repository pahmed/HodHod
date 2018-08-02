//
//  ReportLostPersonViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Kingfisher

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
    
    func imageData() -> String? {
        return image
            .map({ $0.kf.resize(to: CGSize(width: 200, height: 200), for: .aspectFit)})
            .flatMap({ UIImageJPEGRepresentation($0, 1) })
            .map({ $0.base64EncodedString() })
    }
    
    // firebase
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
    }

    @IBAction func takePhotoAction(_ sender: Any) {
        showimagePicker()
    }
    
    @IBAction func reportAction(_ sender: Any) {
        
        let name = nameTextField.text ?? ""
        let id = idTextField.text ?? ""
        
        guard image != nil || name.isEmpty == false || id.isEmpty == false else {
            Alert(title: NSLocalizedString("Name, photo, or id is required", comment: ""), message: nil)
                .show(in: self)
            return
        }
        
        var info: [String: Any] = [:]
        info["reporterID"] = "ali"
        info["personID"] = id
        info["personName"] = name
        info["date"] = Date().timeIntervalSince1970
        info["imageData"] = imageData()
        
        let caseID = UUID().uuidString
        
        ref.child("reports/lostPersons/\(caseID)/").setValue(info)
        
        Alert(
            title: NSLocalizedString("Completed!", comment: ""),
            message: NSLocalizedString("Report has been submitted successfully", comment: "")
        ).add(action: UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })).show(in: self)
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
