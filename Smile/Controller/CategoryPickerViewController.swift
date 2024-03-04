import UIKit

class CategoryPickerViewController: UITableViewController {
    let categories = [
        "#journal",
        "#happy",
        "#sad",
        "#betrayed",
        "#wish",
        "#prayer",
        "#promise",
        "#reminder",
        "#information",
        "#opinion",
        "#commentary",
        "#observation",
        "#achievement",
        "#warning",
        "#NOTE",
        "#TODO"
    ]

    var selectedCategory: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
}

extension CategoryPickerViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = categories[indexPath.row]
        selectedCategory = item
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: K.categoryUnwindSegueIdentifier, sender: cell)
    }
}
