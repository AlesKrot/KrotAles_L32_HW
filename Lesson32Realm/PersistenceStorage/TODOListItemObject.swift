//
//  TODOListItemObject.swift
//  RealmTutorial
//
//  Created by Max Bystryk on 05.02.2022.
//

import Foundation
import RealmSwift

class TODOListItemObject: Object {
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var lastUpdatedDate: Date
    @Persisted var createdDate: Date
    @Persisted(primaryKey: true) var id: String
    
    convenience init(with item: TODOListItem) {
        self.init()
        self.title = item.title
        self.body = item.body
        self.lastUpdatedDate = item.lastUpdatedDate
        self.createdDate = item.createdDate
        self.id = String(createdDate.timeIntervalSince1970)
    }
    
    var item: TODOListItem {
        TODOListItem(title: title, body: body, lastUpdatedDate: lastUpdatedDate, createdDate: createdDate)
    }
}
