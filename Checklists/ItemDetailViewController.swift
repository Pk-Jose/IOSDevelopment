//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Jose Sosa on 8/24/22.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject { // custom delegate and methods
    func itemDetialViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetialViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetialViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit { // Enables the done button when user taps on discloser button
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // Adds Focus to text field
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
        
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.itemDetialViewControllerDidCancel(self)
    }
    
    @IBAction func done() { // Determines if a new cell is being created or being edited
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetialViewController(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetialViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let StringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: StringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }
}
