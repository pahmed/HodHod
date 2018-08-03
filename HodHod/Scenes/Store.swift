//
//  Database.swift
//  HodHod
//
//  Created by Ahmed Ibrahim on 8/2/18.
//  Copyright © 2018 Ahmed Ibrahim. All rights reserved.
//

import Foundation
import FirebaseDatabase
import SwiftLocation
import CoreLocation
import INTULocationManager

class Store {
    
    static let shared = Store()
    let ref: DatabaseReference
    var currentUser: User? {
        didSet {
            updateUsersLocation()
        }
    }
    
    private(set) var personByID: [String: Person] = [:]
    private var locationToken: LocationRequest!
    private var currentLocation: CLLocation? {
        didSet {
            guard let location = currentLocation else { return }
            store(location: location)
        }
    }
    
    init() {
        ref = Database.database().reference()
        
        ref.child("reporters").child("lostPersons").observe(.value) { [weak self] (snapshot) in
            
            guard let info = snapshot.value as? [String: Any] else { return }
            
            self?.indexLostPersons(for: info)
            
            print("snapshot value: \(String(describing: snapshot.value))")
        }
    }
    
    func store(location: CLLocation) {
        guard let user = currentUser else { return }
        
        ref.child("reporters/\(user.id)/name").setValue(user.id)
        ref.child("reporters/\(user.id)/lat").setValue(location.coordinate.latitude)
        ref.child("reporters/\(user.id)/lon").setValue(location.coordinate.longitude)
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
    
    func updateUsersLocation() {
        INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 30) { [weak self] (location, _, _) in
            guard let location = location else { return }
            
            self?.currentLocation = location
        }
        
//        Locator.requestAuthorizationIfNeeded(.always)
//        Locator.currentPosition(accuracy: .block, onSuccess: { [weak self] (location) -> (Void) in
//            self?.currentLocation = location
//        }, onFail: { error, last in
//
//        })
    }
    
    func reportFatigue(completion: @escaping (Bool) -> ()) {
        guard let user = currentUser else {
            completion(false)
            return
        }
        
        INTULocationManager.sharedInstance().requestLocation(withDesiredAccuracy: .neighborhood, timeout: 30) { [weak self] (location, _, _) in
            guard let location = location else { return }
            
            let id = UUID().uuidString
            
            let info: [String: Any] = [
                "reporterID": user.id,
                "type": "fatigue",
                "date": Date().timeIntervalSince1970,
                "lat": location.coordinate.latitude,
                "lon": location.coordinate.longitude,
                ]
            
            self?.ref.child("reports/\(id)").setValue(info)
            
            completion(true)
        }
        
//        Locator.requestAuthorizationIfNeeded(.always)
//        Locator.currentPosition(accuracy: .neighborhood, onSuccess: { [weak self] (location) -> (Void) in
//            
//            let id = UUID().uuidString
//            
//            let info: [String: Any] = [
//                "reporterID": user.id,
//                "type": "fatigue",
//                "date": Date().timeIntervalSince1970,
//                "lat": location.coordinate.latitude,
//                "lon": location.coordinate.longitude,
//            ]
//            
//            self?.ref.child("reports/\(id)").setValue(info)
//            
//            completion(true)
//            
//            }, onFail: { error, last in
//                completion(false)
//        })
    }
}
