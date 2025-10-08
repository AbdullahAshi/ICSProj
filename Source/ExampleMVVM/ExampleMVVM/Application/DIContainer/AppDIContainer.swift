import Foundation
import Common
import DataLayer
import DomainLayer

public final class AppDIContainer: DIContainerDomainLayerProtocol {
    private let diContainer: Common.DIContainer
    private let dataLayerDIContainer: DataLayer.DIContainerDataLayer
    private let domainLayerDIContainer: DomainLayer.DIContainerDomainLayer

    public init() {
        self.diContainer = Common.DIContainer()
        let tempDataLayerDIContainer = DataLayer.DIContainerDataLayer()
        self.dataLayerDIContainer = tempDataLayerDIContainer
        self.domainLayerDIContainer = DomainLayer.DIContainerDomainLayer(dataLayerDIContainer: tempDataLayerDIContainer)
    }
    
    
    public func makeFetchRecentMovieQueriesUseCase() -> DomainLayer.FetchRecentMovieQueriesUseCase? {
        domainLayerDIContainer.makeFetchRecentMovieQueriesUseCase()
    }
    
}
