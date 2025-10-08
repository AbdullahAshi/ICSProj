import Combine
import Foundation
import UIKit
import DomainLayer

public final class ApplicationCoordinator: Coordinating {

    // MARK: - Properties

    let parent: Coordinating? = nil
    var children: [Coordinating] = []

    private var window: WindowType!
    // MARK: - Initialisers

    public init() {
    }

    // MARK: - Public

    @MainActor public func start(on window: WindowType,
                                 moviesRepository: DomainLayer.MoviesRepository,
                                 moviesQueriesRepository: DomainLayer.MoviesQueriesRepository,
                                 posterImagesRepository: DomainLayer.PosterImagesRepository,
                                 appDIContainer: DomainLayer.DIContainerDomainLayerProtocol
    ) {
        self.window = window
        let moviesSearchCoordinator = MoviesSearchCoordinator(parent: self)
        addChild(moviesSearchCoordinator)
        moviesSearchCoordinator.start(on: window, containerDomainLayer: appDIContainer)
        window.makeKeyAndVisible()
    }
}
