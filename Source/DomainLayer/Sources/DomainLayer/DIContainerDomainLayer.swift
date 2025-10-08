//
//  DIContainerDomainLayer.swift
//  DomainLayer
//
//  Created by Abdullah Alashi on 8/10/2025.
//

import Foundation
import Common

// Protocol to abstract the DIContainerDataLayer
public protocol DIContainerDataLayerProtocol {
    func makePosterImagesRepository() -> PosterImagesRepository
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository
}

public protocol DIContainerDomainLayerProtocol {
    func makeFetchRecentMovieQueriesUseCase() -> FetchRecentMovieQueriesUseCase?
}

// DIContainerDataLayer implementation
public final class DIContainerDomainLayer: DIContainerDomainLayerProtocol {
    private let diContainer: Common.DIContainer
    private let dataLayerDIContainer: DIContainerDataLayerProtocol

    public init(dataLayerDIContainer: DIContainerDataLayerProtocol) {
        self.diContainer = Common.DIContainer()
        self.dataLayerDIContainer = dataLayerDIContainer
        registerDependencies()
    }

//    public func resolve<Service>(_ type: Service.Type) -> Service? {
//        return diContainer.resolve(type)
//    }

    private func registerDependencies() {
        // Example of registering dependencies
        diContainer.register(FetchRecentMovieQueriesUseCase.self, factory: {
            FetchRecentMovieQueriesUseCase(moviesQueriesRepository: self.dataLayerDIContainer.makeMoviesQueriesRepository())
        }, lifetime: .singleton)
        
        // Add more registrations as needed
    }

    // MARK: - Factory Methods

    public func makeFetchRecentMovieQueriesUseCase() -> FetchRecentMovieQueriesUseCase? {
        
        return diContainer.resolve(FetchRecentMovieQueriesUseCase.self)
    }
//
//    private func makeDataTransferService() -> DataTransferService {
//        return DefaultDataTransferService(with: makeNetworkService())
//    }
//    
//    public func makePosterImagesRepository() -> DomainLayer.PosterImagesRepository {
//        return DefaultPosterImagesRepository(dataTransferService: makeDataTransferService())
//    }
}
