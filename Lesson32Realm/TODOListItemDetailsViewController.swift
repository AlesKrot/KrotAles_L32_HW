//
//  TODOListItemDetailsViewController.swift
//  RealmTutorial
//
//  Created by Max Bystryk on 06.02.2022.
//

import Foundation
import UIKit

protocol TODOListItemDetailsDelegate {
    func toDoListItemDetailsViewController(_ controller:  TODOListItemDetailsViewController, didFinishEditingOfItem item: TODOListItem)
    
    func removeItemToDoListItemDetailsViewController(_ controller:  TODOListItemDetailsViewController, didRemoveOfItem item: TODOListItem)
}

class TODOListItemDetailsViewController: UIViewController {
    @IBOutlet weak var textView: UITextView?
    
    var delegate: TODOListItemDetailsDelegate?
    var currentItem: TODOListItem?
    var oldValueTextView: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView?.text = currentItem?.body
        oldValueTextView = textView?.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard var currentItem = currentItem else { return }
        let body = textView?.text ?? ""
        
        if body == "" && oldValueTextView == "" {
            print("Notes' body is empty")
        } else if oldValueTextView != "" && body == "" {
            DispatchQueue.main.async {
                self.showAlert(title: "Delete note?", message: "Do you want to remove the note in the trash?")
            }
        } else {
            currentItem.body = body
            currentItem.title = body.split(separator: "\n").first?.base ?? "Item"
            currentItem.lastUpdatedDate = .now
            
            delegate?.toDoListItemDetailsViewController(self,
                                                        didFinishEditingOfItem: currentItem)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
            delegate?.removeItemToDoListItemDetailsViewController(self, didRemoveOfItem: currentItem!)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
    }
}
