//
//  InMemoryStorageManager.swift
//  Lesson32Realm
//
//  Created by Max Bystryk on 07.02.2022.
//

import Foundation

class InMemoryStorageManager: PersistenceManager {
    private var items: [TODOListItem] = []
    
    func save(item: TODOListItem) {
        if let itemIndex = items.firstIndex(where: { $0.createdDate == item.createdDate }) {
            items[itemIndex] = item
        } else {
            items.append(item)
        }
    }
    
    func remove(index: Int) {
        
    }
    
    func loadAllItems() -> [TODOListItem]? {
        return items
    }
}
