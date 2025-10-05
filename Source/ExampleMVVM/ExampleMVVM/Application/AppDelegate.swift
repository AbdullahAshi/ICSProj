import UIKit
import PresentationLayer
import DomainLayer // Use abstractions from DomainLayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    let appDIContainer = AppDIContainer.shared

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        AppAppearance.setupAppearance()
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController

//        // Register dependencies
//        let apiDataTransferService: DataTransferServiceProtocol = DefaultDataTransferService(
//            with: NetworkService() // Placeholder: NetworkService implementation is missing
//        )
//        let imageDataTransferService: ImageDataTransferServiceProtocol = ImageDataTransferService() // Placeholder: Implementation is missing
//
//        let moviesSceneDependencies = MoviesSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService,
//            imageDataTransferService: imageDataTransferService
//        )
//        appDIContainer.register(MoviesSceneDIContainer.self) {
//            MoviesSceneDIContainer(dependencies: moviesSceneDependencies)
//        }
//        let moviesSceneDIContainer = appDIContainer.resolve(MoviesSceneDIContainer.self)!
//        appFlowCoordinator = AppFlowCoordinator(
//            navigationController: navigationController,
//            dependencies: moviesSceneDIContainer // Fixed argument label
//        )
//        appFlowCoordinator?.start()
//        window?.makeKeyAndVisible()
        
        

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
//        CoreDataStorage.shared.saveContext()
    }
}
