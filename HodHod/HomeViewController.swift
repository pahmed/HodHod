//
//  HomeViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController{
    
    @IBOutlet var cardViews: [UIView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}
