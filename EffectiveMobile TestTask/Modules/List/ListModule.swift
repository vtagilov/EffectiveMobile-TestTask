final class ListModule: ModuleFactory {
    typealias ViewController = ListViewController
    typealias ModuleContext = ListModuleContext
    
    static func createModule(_ context: ListModuleContext) -> ViewController {
        let view = ListViewController()
        let interactor = ListInteractor(networkManager: context.networkManager)
        let presenter = ListPresenterImpl(view: view, interactor: interactor)
        let router = ListRouter(coreRouter: context.coreRouter, view: view)

        view.presenter = presenter
        interactor.presenter = presenter
        presenter.router = router
        
        return view
    }
}

struct ListModuleContext: Context {
    let networkManager: NetworkManager
    let coreRouter: CoreRouter
}
