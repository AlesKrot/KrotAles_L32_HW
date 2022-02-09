//
//  TODOListDataSource.swift
//  RealmTutorial
//
//  Created by Max Bystryk on 05.02.2022.
//

import Foundation
import UIKit

class TODOListDataSource: NSObject, UITableViewDataSource {
    var items: [TODOListItem]?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = items else { return UITableViewCell() }

        let id = "default"
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: id) {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: id)
        }
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    
}
