import UIKit

protocol ListView: BaseView {
    var presenter: ListPresenter! { get }
    var tableViewDataSource: ToDoTableAdapter? { get set }
    func updateItemsCounter(_ count: Int)
    func showError(_ type: ListViewErrorType)
    func updateSearchText(_ text: String)
}

enum ListViewErrorType {
    case microphoneUnavailable
    case networkError
}

final class ListViewController: UIViewController, ListView {
    var presenter: ListPresenter!
    
    weak var tableViewDataSource: ToDoTableAdapter? {
        didSet {
            tableView.delegate = tableViewDataSource
            tableView.dataSource = tableViewDataSource
            tableViewDataSource?.tableView = tableView
        }
    }
    
    private lazy var titleLabel = UILabel()
    private lazy var searchBar = SearchBar()
    private lazy var tableView = UITableView(frame: .zero, style: .plain)
    private lazy var bottomView = MainBottomView()
    
    override func viewDidLoad() {
        configureView()
    }
    
    func updateSearchText(_ text: String) {
        searchBar.text = text
    }
    
    func updateItemsCounter(_ count: Int) {
        bottomView.updateItemsCount(count)
    }
    
    func showError(_ type: ListViewErrorType) {
        switch type {
        case .microphoneUnavailable:
           print("microphoneUnavailable")
        case .networkError:
            print("networkError")
        }
    }
    
    private func configureView() {
        view.backgroundColor = .primaryBackground
        
        titleLabel.text = "Задачи"
        titleLabel.font = .boldSystemFont(ofSize: 34)
        titleLabel.textAlignment = .left
        
        searchBar.searchDelegate = self
        bottomView.delegate = self

        tableView.register(ToDoCell.self, forCellReuseIdentifier: ToDoCell.reuseIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableHeaderView = nil
        tableView.showsVerticalScrollIndicator = false
        
        for subview in [titleLabel, searchBar, tableView, bottomView] {
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            titleLabel.heightAnchor.constraint(equalToConstant: 56),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 83)
        ])
    }
}

extension ListViewController: SearchBarDelegate {
    func microphoneButtonTapped(_ isSelected: Bool) {
        presenter.toggleSpeechRecognition(isSelected)
    }
    
    func textDidChange(text: String) {
        presenter.searchItems(text)
    }
}

extension ListViewController: BottomViewDelegate {
    func createNewItem() {
        presenter.createNewItem()
    }
}
