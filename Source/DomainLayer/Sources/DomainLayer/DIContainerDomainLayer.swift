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
    func makeMoviesRepository() -> MoviesRepository
}

public protocol DIContainerDomainLayerProtocol {
    func makeFetchRecentMovieQueriesUseCase() -> FetchRecentMovieQueriesUseCase?
    func makeSearchMoviesUseCase() -> SearchMoviesUseCase?
    func makePosterImagesRepository() -> PosterImagesRepository
    func makeMoviesQueriesRepository() -> MoviesQueriesRepository
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
    // MARK: - Dependency Registration
    
    private func registerDependencies() {
        diContainer.register(FetchRecentMovieQueriesUseCase.self, factory: {
            FetchRecentMovieQueriesUseCase(moviesQueriesRepository: self.dataLayerDIContainer.makeMoviesQueriesRepository())
        }, lifetime: .singleton)
        
        diContainer.register(SearchMoviesUseCase.self, factory: {
            DefaultSearchMoviesUseCase(moviesRepository: self.dataLayerDIContainer.makeMoviesRepository(),
                                       moviesQueriesRepository: self.dataLayerDIContainer.makeMoviesQueriesRepository())
        }, lifetime: .transient)
    }

    // MARK: - Factory Methods

    public func makeFetchRecentMovieQueriesUseCase() -> FetchRecentMovieQueriesUseCase? {
        
        return diContainer.resolve(FetchRecentMovieQueriesUseCase.self)
    }
    
    public func makeSearchMoviesUseCase() -> SearchMoviesUseCase? {
        return diContainer.resolve(SearchMoviesUseCase.self)
    }
    
    public func makePosterImagesRepository() -> PosterImagesRepository {
        return dataLayerDIContainer.makePosterImagesRepository()
    }
    
    public func makeMoviesQueriesRepository() -> MoviesQueriesRepository {
        return dataLayerDIContainer.makeMoviesQueriesRepository()
    }
}
