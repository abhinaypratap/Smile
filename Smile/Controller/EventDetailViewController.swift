//
//  AddEventViewController.swift
//  Smile
//
//  Created by Abhinay Pratap on 11/06/22.
//

import UIKit
import CoreData

class EventDetailViewController: UITableViewController {
    
    // MARK: Properties
    var event: Event?
    
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
private extension EventDetailViewController {
    func configureView() {
        guard let event = event else { return }

//        title = ""
        eventTextField.text = event.content
        categoryLabel.text = event.category
    }
    
    func updateItem() {
        guard let newItem = event else { return }
        newItem.content = eventTextField.text
        newItem.category = categoryLabel.text
        newItem.time = Date()
    }

}

//func stringForDate() -> String {
//  guard let date = date else { return "" }
//
//  let dateFormatter = DateFormatter()
//  dateFormatter.dateStyle = .short
//  return dateFormatter.string(from: date)
//}
