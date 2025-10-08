//
//  DIContainerDataLayer.swift
//  DataLayer
//
//  Created by Abdullah Alashi on 8/10/2025.
//

import Foundation
import Common
import DomainLayer

//// Protocol to abstract the DIContainerDataLayer
//public protocol DIContainerDataLayerProtocol {
////    func resolve<Service>(_ type: Service.Type) -> Service?
//    func makePosterImagesRepository() -> DomainLayer.PosterImagesRepository
//}

// DIContainerDataLayer implementation
public final class DIContainerDataLayer: DomainLayer.DIContainerDataLayerProtocol {
    private let diContainer: Common.DIContainer

    public init() {
        self.diContainer = Common.DIContainer()
        registerDependencies()
    }

//    public func resolve<Service>(_ type: Service.Type) -> Service? {
//        return diContainer.resolve(type)
//    }

    private func registerDependencies() {
        // Example of registering dependencies
        diContainer.register(NetworkService.self, factory: makeNetworkService, lifetime: .singleton)
        diContainer.register(DataTransferService.self, factory: makeDataTransferService, lifetime: .singleton)
        // Add more registrations as needed
    }

    // MARK: - Factory Methods

    private func makeNetworkService() -> NetworkService {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: AppConfiguration.apiBaseURL)!,
            queryParameters: [
                "api_key": AppConfiguration.apiKey,
                "language": NSLocale.preferredLanguages.first ?? "en"
            ]
        )
        return DefaultNetworkService(config: config)
    }

    private func makeDataTransferService() -> DataTransferService {
        return DefaultDataTransferService(with: makeNetworkService())
    }
    
    public func makeMoviesQueriesRepository() -> DomainLayer.MoviesQueriesRepository {
        return DefaultMoviesQueriesRepository(moviesQueriesPersistentStorage: CoreDataMoviesQueriesStorage(maxStorageLimit: 10))
    }
    
    public func makeMoviesRepository() -> DomainLayer.MoviesRepository {
        return DefaultMoviesRepository(dataTransferService: makeDataTransferService())
    }
    
    public func makePosterImagesRepository() -> DomainLayer.PosterImagesRepository {
        return DefaultPosterImagesRepository(dataTransferService: makeDataTransferService())
    }
}
