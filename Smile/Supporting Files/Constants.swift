// swiftlint:disable:next type_name
struct K {

    // Cells
    static let defaultCellIdentifier = "Cell"
    static let eventCellIdentifier = "EventCell"
    static let categoryCellIdentifier = "CategoryCell"
    static let cellNibName = "EventCell"

    // Segues
    // static let addEventSegueIdentifier = "EventDetailViewController"
    static let showCategoriesSegueIdentifier = "CategoryPickerViewController"
    static let categoryUnwindSegueIdentifier = "unwindToEventDetail"
    static let editEventSegueIdentifier = "ListToDetailEdit"
    static let addEventSegueIdentifier = "ListToDetailAdd"
}
