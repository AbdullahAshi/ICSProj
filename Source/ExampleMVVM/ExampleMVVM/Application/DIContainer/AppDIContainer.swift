//import Foundation
//import DataLayer
//
//public final class AppDIContainer {
//
//    // MARK: - Network
//    lazy var apiDataTransferService: DataTransferService = {
//        let config = ApiDataNetworkConfig(
//            baseURL: URL(string: AppConfiguration.apiBaseURL)!,
//            queryParameters: [
//                "api_key": AppConfiguration.apiKey,
//                "language": NSLocale.preferredLanguages.first ?? "en"
//            ]
//        )
//        
//        let apiDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: apiDataNetwork)
//    }()
//    lazy var imageDataTransferService: DataTransferService = {
//        let config = ApiDataNetworkConfig(
//            baseURL: URL(string: AppConfiguration.imagesBaseURL)!
//        )
//        let imagesDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: imagesDataNetwork)
//    }()
//    
//    // MARK: - DIContainers of scenes
//    func makeMoviesSceneDIContainer() -> MoviesSceneDIContainer {
//        let dependencies = MoviesSceneDIContainer.Dependencies(
//            apiDataTransferService: apiDataTransferService,
//            imageDataTransferService: imageDataTransferService
//        )
//        return MoviesSceneDIContainer(dependencies: dependencies)
//    }
//}
