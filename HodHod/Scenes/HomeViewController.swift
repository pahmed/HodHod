//
//  HomeViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var cardViews: [UIView]!
    
    var ref: DatabaseReference!
    
    private var foundPerson: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        title = NSLocalizedString("إدارة البلاغات", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        style()
    }
    
    func style() {
        for card in cardViews {
            style(cardView: card)
        }
    }
    
    func style(cardView: UIView) {
        cardView.layer.cornerRadius = 8
        let shadowPath = UIBezierPath(rect: cardView.bounds)
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        cardView.layer.shadowOpacity = 0.5
        cardView.layer.shadowPath = shadowPath.cgPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "lostPersonDetails" {
            let vc = segue.destination as! PersonDetailsViewController
            vc.person = foundPerson
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let id = searchBar.text ?? ""
        
        guard  id.isEmpty == false else {
            Alert(
                title: NSLocalizedString("Please enter a valid search name", comment: ""),
                message: nil
                ).show(in: self)
            
            return
        }
        
        guard let person = Store.shared.personByID[id] else {
            Alert(title: NSLocalizedString("No results found", comment: ""), message: nil)
                .show(in: self)
            return
        }
        
        foundPerson = person
        
        performSegue(withIdentifier: "lostPersonDetails", sender: self)
    }

}
