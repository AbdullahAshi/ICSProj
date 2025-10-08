import UIKit
import PresentationLayer
import DomainLayer
import DataLayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appDIContainer = AppDIContainer()
    // var appFlowCoordinator: AppFlowCoordinator?
    private let applicationCoordinator: ApplicationCoordinator = .init()
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        AppAppearance.setupAppearance()
        
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
        }
//        appFlowCoordinator = AppFlowCoordinator(
//            navigationController: navigationController,
//            appDIContainer: appDIContainer
//        )
//        appFlowCoordinator?.start()
        applicationCoordinator.start(on: window!,
                                     moviesRepository: DataLayer.DefaultMoviesRepository(),
                                     moviesQueriesRepository: DataLayer.DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: CoreDataMoviesQueriesStorage(maxStorageLimit: 10)),
                                     posterImagesRepository: DataLayer.DefaultPosterImagesRepository(),
                                     appDIContainer: appDIContainer)
//        window?.makeKeyAndVisible()
    
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        CoreDataStorage.shared.saveContext()
    }
}
