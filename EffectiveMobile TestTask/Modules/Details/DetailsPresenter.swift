import UIKit
import Foundation

protocol DetailsPresenter: Presenter {
    var view: DetailsView? { get set }
    var router: DetailsRouter? { get set }
    
    func updateText(_ text: String)
    func navigateBack()
}

final class DetailsPresenterImpl: DetailsPresenter {
    weak var view: DetailsView?
    var router: DetailsRouter?
    private let interactor: DetailsInteractor
    
    private var item: ToDoItem
    
    init(view: DetailsView, interactor: DetailsInteractor, toDoItem: ToDoItem) {
        self.interactor = interactor
        self.view = view
        self.item = toDoItem
        view.configure(item)
    }
    
    func updateText(_ text: String) {
        item.todo = text
        CoreDataManager.shared.updateItem(item)
    }
    
    func navigateBack() {
        router?.navigateBack(item: item)
    }
}
