import UIKit
import CoreData

class EventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // swiftlint:disable:next force_cast
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var eventArray = [Event]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAllItems()
        scrollToBottom(animation: false)
    }

    fileprivate func configure() {
        title = "Koyal"
        tableView.dataSource = self
        tableView.delegate = self
        getAllItems()
        scrollToBottom(animation: false)
    }

    func scrollToBottom(animation: Bool) {
        DispatchQueue.main.async {
            if self.tableView.numberOfRows(inSection: 0) > 0 {
                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: animation)
            }
        }
    }
}

extension EventViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        eventArray.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: K.eventCellIdentifier, for: indexPath) as! EventCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM YYYY hh:mm a"
        cell.timeLabel.text = dateFormatter.string(from: eventArray[indexPath.row].time!)
        cell.contentLabel.text = eventArray[indexPath.row].content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension EventViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let item = eventArray[indexPath.row]

        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
            let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.content
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard
                    let field = alert.textFields?.first,
                    let newContent = field.text,
                    !newContent.isEmpty
                else {
                    return
                }
                self?.updateItem(item: item, newContent: newContent)
            }))
            self.present(alert, animated: true)
        }))

        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteItem(item: item)
        }))

        present(sheet, animated: true)
    }
}

extension EventViewController {
    @IBAction func cancelToEventViewController(_ segue: UIStoryboardSegue) {}
}

// CoreData
extension EventViewController {
    func getAllItems() {
        do {
            eventArray = try context.fetch(Event.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching data from context \(error)")
        }
    }

    func createItem(content: String) {
        // TODO: - While adding the category here, go to the Event entity and
        // make the category a non-optional
        let newItem = Event(context: context)
        newItem.content = content
        newItem.time = Date()
        eventArray.append(newItem)
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error saving context \(error)")
        }
        scrollToBottom(animation: true)
    }

    func updateItem(item: Event, newContent: String) {
        item.content = newContent
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error saving context \(error)")
        }
    }

    func deleteItem(item: Event) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch {
            print("Error saving context \(error)")
        }
    }
}
