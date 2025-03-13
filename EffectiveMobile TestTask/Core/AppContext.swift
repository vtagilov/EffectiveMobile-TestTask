final class AppContext {
    static let shared = AppContext()
    
    let networkManager: NetworkManager
    let coreRouter: CoreRouter

    init() {
        self.networkManager = NetworkManager()
        self.coreRouter = CoreRouterImpl()
    }
}
