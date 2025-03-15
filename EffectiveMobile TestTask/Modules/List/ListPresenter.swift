import UIKit
import Foundation

protocol ListPresenter: Presenter {
    var view: ListView? { get set }
    var router: ListRouter? { get set }
    
    func toggleSpeechRecognition(_ isStarts: Bool)
    func searchItems(_ text: String)
    func createNewItem()
    func editItem(_ model: ToDoItem)
    func updateTableViewItem(_ model: ToDoItem)
}

final class ListPresenterImpl: ListPresenter {
    weak var view: ListView?
    var router: ListRouter?
    private let interactor: ListInteractor
    
    private lazy var speechRecognitionService = SpeechRecognitionService()
    private lazy var tableDataSource = ToDoTableAdapter()
    private var items = [ToDoItem]()
    
    init(view: ListView, interactor: ListInteractor) {
        self.interactor = interactor
        self.view = view
        view.tableViewDataSource = tableDataSource
        tableDataSource.cellDelegate = self
        loadItems()
    }
    
    func toggleSpeechRecognition(_ isStarts: Bool) {
        if isStarts {
            speechRecognitionService.requestAuthorization { [weak self] isAuthorized in
                guard let sSelf = self else { return }
                if !isAuthorized {
                    sSelf.view?.showError(.microphoneUnavailable)
                    return
                }
                sSelf.speechRecognitionService.onTextRecognized = { [weak self] text in
                    guard let sSelf = self else { return }
                    sSelf.view?.updateSearchText(text)
                }
                sSelf.speechRecognitionService.startRecognition()
            }
        } else {
            speechRecognitionService.stopRecognition()
        }
    }
    
    func searchItems(_ text: String) {
        if text == "" {
            tableDataSource.setModels(items)
            view?.updateItemsCounter(items.count)
            return
        }
        let filteredItems = items.filter { $0.todo.lowercased().contains(text.lowercased()) }
        tableDataSource.setModels(filteredItems)
        view?.updateItemsCounter(filteredItems.count)
    }
    
    func updateItem(_ model: ToDoItem) {
        CoreDataManager.shared.updateItem(model)
    }
    
    func updateTableViewItem(_ model: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == model.id }) {
            items[index] = model
        }
        tableDataSource.setModels(items)
        view?.updateItemsCounter(items.count)
    }
    
    func createNewItem() {
        let newId = (items.map { $0.id }.max() ?? 0) + 1
        let newItem = ToDoItem(id: newId, todo: "", completed: false, userId: 0)
        CoreDataManager.shared.saveItems([newItem])
        items.append(newItem)
        router?.openDetailsScreen(newItem)
    }
    
    func editItem(_ model: ToDoItem) {
        router?.openDetailsScreen(model)
    }
    
    private func loadItems() {
        let items = CoreDataManager.shared.fetchItems()
        if !items.isEmpty {
            updateViewItems(items)
            self.items = items
            return
        }
        
        let url = Endpoint.todos.urlWithParams([.limit: "0"])
        interactor.fetchItems(url: url) { [weak self] result in
            DispatchQueue.main.async {
                guard let sSelf = self else { return }
                switch result {
                case .success(let response):
                    sSelf.updateViewItems(items)
                    CoreDataManager.shared.saveItems(response.todos)
                    sSelf.items = items
                case .failure(_):
                    sSelf.view?.showError(.networkError)
                }
            }
        }
    }
    
    private func updateViewItems(_ items: [ToDoItem]) {
        view?.updateItemsCounter(items.count)
        tableDataSource.setModels(items)
    }
}

extension ListPresenterImpl: ToDoCellDelegate {
    func updateModel(_ model: ToDoItem) {
        updateItem(model)
    }
    
    func editButtonTapped(model: ToDoItem) {
        editItem(model)
    }
    
    func shareButtonTapped(model: ToDoItem) {
        router?.shareText(model.description)
    }
    
    func deleteButtonTapped(model: ToDoItem) {
        if let index = items.firstIndex(where: { $0.id == model.id }) {
            items.remove(at: index)
            updateViewItems(items)
            CoreDataManager.shared.deleteItem(model)
        }
    }
}
