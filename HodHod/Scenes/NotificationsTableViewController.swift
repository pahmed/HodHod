//
//  NotificationsTableViewController.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/3/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NotificationsTableViewController: UITableViewController {

    var ref: DatabaseReference!
    private var notifications: [[String: Any]] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "الاشعارات"
        
        ref = Database.database().reference()
        
        guard let user = Store.shared.currentUser else { return }
        
        ref.child("notifications/\(user.id)/").observe(.value) { [weak self] (snapshot) in
            
            guard let info = snapshot.value as? [String: Any] else { return }
            
            var notifications: [[String: Any]] = []
            
            for (_, value) in info {
                guard let item = value as? [String: Any] else { continue }
                
                notifications.append(item)
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.notifications = notifications
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = notifications[indexPath.row]
        
        cell.textLabel?.text = item["message"] as? String
        
        return cell
    }

}
