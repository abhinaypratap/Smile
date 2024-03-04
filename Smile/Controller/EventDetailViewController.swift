import UIKit
import CoreData

class EventDetailViewController: UITableViewController {

    // swiftlint:disable:next force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!

    var event: Event?
    var category: String? {
        willSet {
            categoryLabel.text = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        createItem(content: eventTextField.text!)
        navigationController?.popViewController(animated: true)
    }
}

// Unwind Segue
extension EventDetailViewController {
    @IBAction func unwindWithSelectedCategory(segue: UIStoryboardSegue) {
        if let source = segue.source as? CategoryPickerViewController {
            category = source.selectedCategory
        }
    }
}

extension EventDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        eventTextField.resignFirstResponder()
        return true
    }
}

extension EventDetailViewController {
    fileprivate func configure() {
        categoryLabel.text = ""
        eventTextField.delegate = self
        eventTextField.returnKeyType = .done
        eventTextField.autocorrectionType = .no
    }

    func createItem(content: String) {
        let newEvent = Event(context: context)
        newEvent.content = content
        newEvent.time = Date()
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
}
