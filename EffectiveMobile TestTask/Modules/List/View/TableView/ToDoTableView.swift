import UIKit

final class ToDoTableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var tableView: UITableView?
    weak var cellDelegate: ToDoCellDelegate?
    
    private var models: [ToDoItem] = []

    func setModels(_ newModels: [ToDoItem]) {
        self.models = newModels
        tableView?.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoCell.reuseIdentifier) as? ToDoCell else {
            return UITableViewCell()
        }
        cell.configureCell(model: models[indexPath.row])
        cell.delegate = cellDelegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
