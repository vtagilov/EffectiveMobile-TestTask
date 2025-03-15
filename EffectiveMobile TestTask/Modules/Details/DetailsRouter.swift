import UIKit

final class DetailsRouter: Router {
    weak var view: UIViewController?
    var coreRouter: CoreRouter
    
    init(coreRouter: CoreRouter, view: UIViewController) {
        self.coreRouter = coreRouter
        self.view = view
    }
    
    func navigateBack(item: ToDoItem) {
        coreRouter.navigateBackToMainScreen(model: item)
    }
}
