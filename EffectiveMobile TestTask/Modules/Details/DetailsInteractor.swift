import Foundation
import UIKit

final class DetailsInteractor: Interactor {
    weak var presenter: DetailsPresenter!
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}
