import UIKit

final class ListRouter: Router {
    weak var view: UIViewController?
    
    init(view: UIViewController) {
        self.view = view
    }
    
    func openDetailsScreen(_ model: ToDoItem? = nil) {
        
    }
    
    func shareText(_ text: String) {
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        view?.present(activityVC, animated: true)
    }
}
