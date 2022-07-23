//
//  ViewController.swift
//  Smile
//
//  Created by Abhinay Pratap on 09/06/22.
//

import UIKit
import CoreData

class EventViewController: UIViewController {
  
  @IBOutlet weak var eventTableView: UITableView!
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  private var eventArray = [Event]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Koyal"
    eventTableView.dataSource = self
    eventTableView.delegate = self
    getAllItems()
    scrollToBottom(animation: false)
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    let alert = UIAlertController(title: "Add New Item",
                                  message: "",
                                  preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item",
                               style: .default) { [weak self] (action) in
      guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
        return
      }
      self?.createItem(content: text)
    }
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Add new moment"
    }
    alert.addAction(action)
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true, completion: nil)
  }
  
  func scrollToBottom(animation: Bool) {
    DispatchQueue.main.async {
      if self.eventTableView.numberOfRows(inSection: 0) > 0 {
        let indexPath = IndexPath(row: self.eventTableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.eventTableView.scrollToRow(at: indexPath, at: .top, animated: animation)
      }
    }
  }
}

// MARK: - UITableViewDataSource
extension EventViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    eventArray.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = eventTableView.dequeueReusableCell(
      withIdentifier: K.eventCellIdentifier, for: indexPath) as! EventCell
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
    eventTableView.deselectRow(at: indexPath, animated: true)
    let item = eventArray[indexPath.row]
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
      let alert = UIAlertController(title: "Edit Item", message: "Edit your item", preferredStyle: .alert)
      alert.addTextField(configurationHandler: nil)
      alert.textFields?.first?.text = item.content
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
        guard let field = alert.textFields?.first, let newContent = field.text, !newContent.isEmpty else {
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
  @IBAction func savePlayerDetail(_ segue: UIStoryboardSegue) {}
}

// MARK: Navigation
extension EventViewController {
  //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //        if segue.identifier == K.addEventSegueIdentifier {
  //            let addEventVC = segue.destination as! AddEventViewController
  //            addEventVC.isModalInPresentation = trwue
  //        }
  //    }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == K.editEventSegueIdentifier {
      
    } else if segue.identifier == K.addEventSegueIdentifier {
      
    }
  }
}

// MARK: CoreData
extension EventViewController {
  func getAllItems() {
    do {
      eventArray = try context.fetch(Event.fetchRequest())
      DispatchQueue.main.async {
        self.eventTableView.reloadData()
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
