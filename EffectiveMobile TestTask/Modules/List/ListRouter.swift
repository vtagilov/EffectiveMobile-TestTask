import UIKit

final class ListRouter: Router {
    weak var view: UIViewController?
    var coreRouter: CoreRouter
    
    init(coreRouter: CoreRouter, view: UIViewController) {
        self.coreRouter = coreRouter
        self.view = view
    }
    
    func openDetailsScreen(_ model: ToDoItem) {
        coreRouter.navigateToDetailScreen(model: model)
    }
    
    func shareText(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        view?.present(activityVC, animated: true)
    }
}
