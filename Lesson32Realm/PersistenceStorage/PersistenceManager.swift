//
//  PersistenceManager.swift
//  RealmTutorial
//
//  Created by Max Bystryk on 05.02.2022.
//

import Foundation
import RealmSwift

class RealmManager: PersistenceManager {
    private var realm: Realm!
    private var schemaVersion: UInt64 = 8
    
    init() {
        let config = Realm.Configuration(schemaVersion: schemaVersion) { migration, oldSchemaVersion in
            migration.renameProperty(onType: TODOListItemObject.className(), from: "identifier", to: "id")
        }
        // Use this configuration when opening realms
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
    }
    
    func save(item: TODOListItem) {
//        if let object = realm.objects(TODOListItemObject.self)
//            .where({ $0.createdDate == item.createdDate }).first {
//            
//            try? realm.write {
//                object.body = item.body
//                object.title = item.title
//                object.lastUpdatedDate = item.lastUpdatedDate
//            }
//
//            return
//        }
        
        if let object = realm.object(ofType: TODOListItemObject.self, forPrimaryKey: String(item.createdDate.timeIntervalSince1970)) {
            try? realm.write {
                object.body = item.body
                object.title = item.title
                object.lastUpdatedDate = item.lastUpdatedDate
            }

            return
        }
        
        let object = TODOListItemObject(with: item)
        try? realm.write {
            realm.add(object)
        }
    }
    
    func remove(index: Int) {
        let objects = realm.objects(TODOListItemObject.self)
        let object = objects[index]
        try! realm.write {
            realm.delete(object)
        }
    }
//    func remove(item: TODOListItem) {
//        //let objects = realm.objects(TODOListItemObject.self)
//        let object = realm.object(ofType: TODOListItemObject.self, forPrimaryKey: item.createdDate)
//        try! realm.write {
//            realm.delete(object)
//        }
//    }
    
    func loadAllItems() -> [TODOListItem]? {
        let objects = realm.objects(TODOListItemObject.self)
        return objects.map { $0.item }
    }
}
