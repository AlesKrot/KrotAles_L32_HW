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
    var persistenceManager: PersistenceManager?
    
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
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: id)
        }
        
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = dateToString(value: item.lastUpdatedDate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        
        persistenceManager = RealmManager()
        persistenceManager?.remove(item: items![indexPath.row])
        items?.remove(at: indexPath.row)
        tableView.endUpdates()
    }
}

private func dateToString(value: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM.dd.yyyy, HH:mm"
    let dateString = dateFormatter.string(from: value)
    return "Last update: " + dateString
}
