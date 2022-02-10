//
//  ViewController.swift
//  RealmTutorial
//
//  Created by Max Bystryk on 05.02.2022.
//

import UIKit

protocol PersistenceManager {
    func save(item: TODOListItem)
    func remove(item: TODOListItem)
    func loadAllItems() -> [TODOListItem]?
}

class TODOListViewController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var persistenceManager: PersistenceManager?
    let dataSource = TODOListDataSource()
    var selectedItem: TODOListItem? //Empty for new item
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performInitialConfiguration()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadStoredItems()
    }
    
    func performInitialConfiguration() {
        //any other Persistence Manager protocol conformed object could be injicted from outside
        persistenceManager = RealmManager()
        //persistenceManager = InMemoryStorageManager()
        tableView.delegate = self
        tableView.dataSource = dataSource
    }
    
    func loadStoredItems() {
        let items = persistenceManager?.loadAllItems()
        dataSource.items = items
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "todoDetails" {
        guard let destination = segue.destination as? TODOListItemDetailsViewController else { return }
            destination.currentItem = selectedItem
            destination.delegate = self
        }
    }
    
    @IBAction func onTapAddButton(_ sender: UIBarButtonItem) {
        selectedItem = TODOListItem(title: "", body: "", lastUpdatedDate: .now, createdDate: .now)
        performSegue(withIdentifier: "todoDetails", sender: self)
    }
}

extension TODOListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataSource.items?[indexPath.row] else { return }
        selectedItem = item
        performSegue(withIdentifier: "todoDetails", sender: self)
    }
}

extension TODOListViewController: TODOListItemDetailsDelegate {
    func toDoListItemDetailsViewController(_ controller: TODOListItemDetailsViewController, didFinishEditingOfItem item: TODOListItem) {
        persistenceManager?.save(item: item)
        loadStoredItems()
    }
    
    func removeItemToDoListItemDetailsViewController(_ controller: TODOListItemDetailsViewController, didRemoveOfItem item: TODOListItem) {
        persistenceManager?.remove(item: item)
        loadStoredItems()
    }
}
