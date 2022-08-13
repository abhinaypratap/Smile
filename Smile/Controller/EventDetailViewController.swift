//
//  AddEventViewController.swift
//  Smile
//
//  Created by Abhinay Pratap on 11/06/22.
//

import UIKit
import CoreData

class EventDetailViewController: UITableViewController {
    
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: Properties
    var event: Event?
    
  @IBAction func donePressed(_ sender: UIBarButtonItem) {
//    createItem(content: "test")
    print(eventTextField.text!)
  }
  
  func createItem(content: String) {
    print("createItem")
    let newItem = Event(context: context)
    newItem.content = content
    newItem.time = Date()
    do {
      
      try context.save()
    } catch {
      print("Error saving context \(error)")
    }
  }
  // MARK: IBOutlets
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var ctgry: String? {
        willSet {
            categoryLabel.text = newValue
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryLabel.text = ""
//        categoryLabel.textColor = .systemPink
//        eventTextField.becomeFirstResponder()
      eventTextField.delegate = self
      eventTextField.returnKeyType = .done
      eventTextField.autocorrectionType = .no
    }
}

// MARK: Unwind Segue
extension EventDetailViewController {
    @IBAction func unwindWithSelectedCategory(segue: UIStoryboardSegue) {
        if let source = segue.source as? CategoryPickerViewController {
            ctgry = source.selectedCategory
        }
    }
}

// MARK: Private
//private extension EventDetailViewController {
//    func configureView() {
//        guard let event = event else { return }
//
////        title = ""
//        eventTextField.text = event.content
//        categoryLabel.text = event.category
//    }
//
//    func updateItem() {
//        guard let newItem = event else { return }
//        newItem.content = eventTextField.text
//        newItem.category = categoryLabel.text
//        newItem.time = Date()
//    }
//
//}

//func stringForDate() -> String {
//  guard let date = date else { return "" }
//
//  let dateFormatter = DateFormatter()
//  dateFormatter.dateStyle = .short
//  return dateFormatter.string(from: date)
//}


extension EventDetailViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    eventTextField.resignFirstResponder()
//    print(eventTextField.text!)
    return true
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    createItem(content: eventTextField.text!)
    return true
  }
}
