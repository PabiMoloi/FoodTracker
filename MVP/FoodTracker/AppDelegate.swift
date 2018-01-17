import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container: Container = {
        let container = Container()

        container.register(MealApi.self) { _ in MealApi() }
        container.register(MealService.self) { r in
            MealService(mealApi: r.resolve(MealApi.self)!)
        }

        container.register(MealPresenter.self) { r in
            MealPresenter(mealService: r.resolve(MealService.self)!)
        }
        container.register(MealTablePresenter.self) { r in
            MealTablePresenter(mealService: r.resolve(MealService.self)!)
        }

        container.register(MealView.self) { r in
            let controller = MealViewController(nibName: "Meal", bundle: nil)
            controller.mealPresenter = r.resolve(MealPresenter.self)!
            return controller
        }
        container.register(MealTableView.self) { r in
            let controller = MealTableViewController(nibName: "MealList", bundle: nil)
            controller.mealTablePresenter = r.resolve(MealTablePresenter.self)!
            return controller
        }

        return container
    }()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        guard let rootVC = container.resolve(MealTableView.self) as? MealTableViewController else {
            fatalError("Could not get root view controller")
        }
        let navVC = UINavigationController(rootViewController: rootVC)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navVC
        return true
    }

}
