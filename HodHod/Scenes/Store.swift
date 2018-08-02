//
//  Database.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Store {
    
    static let shared = Store()
    let ref: DatabaseReference
    
    private(set) var personByID: [String: Person] = [:]
    
    init() {
        ref = Database.database().reference()
        
        ref.child("reports").child("lostPersons").observe(.value) { [weak self] (snapshot) in
            
            guard let info = snapshot.value as? [String: Any] else { return }
            
            self?.indexLostPersons(for: info)
            
            print("snapshot value: \(String(describing: snapshot.value))")
        }
    }
    
    func indexLostPersons(for snapshot: [String: Any]) {
        for (_, value) in snapshot {
            guard let info  = value as? [String: Any] else { continue }
            
            let date = info["date"] as? TimeInterval
            let personID = info["personID"] as? String
            let personName = info["personName"] as? String
            let reporterID = info["repoterID"] as? String
            let imageData = info["imageData"] as? String
            
            let person = Person(name: personName, personID: personID, imageData: imageData, location: nil)
            
            if let id = personID {
                personByID[id] = person
            }
            
        }
    }
}
