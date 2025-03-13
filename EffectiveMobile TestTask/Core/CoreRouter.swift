import UIKit

protocol CoreRouter: AnyObject {
    var navigationController: UINavigationController { get }
    func navigateToMainScreen()
    func navigateToDetailScreen(model: ToDoItem?)
}

final class CoreRouterImpl: CoreRouter {
    var appContext: AppContext { AppContext.shared }
    var navigationController = UINavigationController()

    func navigateToMainScreen() {
        let context = ListModuleContext(
            networkManager: appContext.networkManager
        )
        let view = ListModule.createModule(context)
        navigationController.pushViewController(view, animated: true)
        
    }
    
    func navigateToDetailScreen(model: ToDoItem?) {
    }
}
