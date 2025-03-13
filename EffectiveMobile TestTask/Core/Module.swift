import UIKit

protocol BaseView: UIViewController { }
protocol Interactor: AnyObject { }
protocol Presenter: AnyObject { }
protocol Router: AnyObject {
    var view: UIViewController? { get set }
}
protocol Context { }

protocol ModuleFactory {
    associatedtype ViewController: UIViewController
    associatedtype ModuleContext: Context

    static func createModule(_ context: ModuleContext) -> ViewController
}
