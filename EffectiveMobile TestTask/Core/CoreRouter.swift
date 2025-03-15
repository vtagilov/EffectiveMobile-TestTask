import UIKit

protocol CoreRouter: AnyObject {
    var navigationController: UINavigationController { get }
    func navigateToMainScreen()
    func navigateToDetailScreen(model: ToDoItem)
    func navigateBackToMainScreen(model: ToDoItem)
}

final class CoreRouterImpl: CoreRouter {
    var appContext: AppContext { AppContext.shared }
    var navigationController = UINavigationController()

    func navigateToMainScreen() {
        let context = ListModuleContext(
            networkManager: appContext.networkManager,
            coreRouter: self
        )
        let view = ListModule.createModule(context)
        navigationController.pushViewController(view, animated: true)
    }
    
    func navigateToDetailScreen(model: ToDoItem) {
        let context = DetailsModuleContext(
            networkManager: appContext.networkManager,
            coreRouter: self,
            toDoItem: model
        )
        let view = DetailsModule.createModule(context)
        navigationController.pushViewController(view, animated: true)
    }
    
    func navigateBackToMainScreen(model: ToDoItem) {
        navigationController.popViewController(animated: true)
        if let view = navigationController.viewControllers.last as? ListView {
            view.presenter.updateTableViewItem(model)
        }
    }
}
