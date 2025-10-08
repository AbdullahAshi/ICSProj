import Foundation
import Common
import DataLayer
import DomainLayer

public final class AppDIContainer: DIContainerDomainLayerProtocol {
    private let domainLayerDIContainer: DomainLayer.DIContainerDomainLayerProtocol

    public init() {
        self.domainLayerDIContainer = DomainLayer.DIContainerDomainLayer(dataLayerDIContainer: DataLayer.DIContainerDataLayer())
    }
    
    
    public func makeFetchRecentMovieQueriesUseCase() -> DomainLayer.FetchRecentMovieQueriesUseCase? {
        domainLayerDIContainer.makeFetchRecentMovieQueriesUseCase()
    }
    
    public func makeSearchMoviesUseCase() -> (any DomainLayer.SearchMoviesUseCase)? {
        domainLayerDIContainer.makeSearchMoviesUseCase()
    }
    
    public func makePosterImagesRepository() -> any DomainLayer.PosterImagesRepository {
        domainLayerDIContainer.makePosterImagesRepository()
    }
    
    public func makeMoviesQueriesRepository() -> any DomainLayer.MoviesQueriesRepository {
        domainLayerDIContainer.makeMoviesQueriesRepository()
    }
    
}
