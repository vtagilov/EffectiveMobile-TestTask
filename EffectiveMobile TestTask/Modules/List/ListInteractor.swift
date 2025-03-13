import Foundation
import UIKit

final class ListInteractor: Interactor {
    weak var presenter: ListPresenter!
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func fetchItems(url: String,  _ completion: @escaping (NetworkResult<ToDoListResponce>) -> Void) {
        networkManager.fetchModel(type: ToDoListResponce.self, urlStr: url, completion)
    }
}
