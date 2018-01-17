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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let rootVC = container.resolve(MealTableView.self) as! MealTableViewController
        let navVC = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navVC
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

