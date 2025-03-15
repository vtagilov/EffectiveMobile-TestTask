final class DetailsModule: ModuleFactory {
    typealias ViewController = DetailsViewController
    typealias ModuleContext = DetailsModuleContext
    
    static func createModule(_ context: DetailsModuleContext) -> ViewController {
        let view = DetailsViewController()
        let interactor = DetailsInteractor(networkManager: context.networkManager)
        let presenter = DetailsPresenterImpl(view: view, interactor: interactor, toDoItem: context.toDoItem)
        let router = DetailsRouter(coreRouter: context.coreRouter, view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        
        return view
    }
}

struct DetailsModuleContext: Context {
    let networkManager: NetworkManager
    let coreRouter: CoreRouter
    let toDoItem: ToDoItem
}
