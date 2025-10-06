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
                                 posterImagesRepository: DomainLayer.PosterImagesRepository
    ) {
        self.window = window
        let ccc = MoviesSearchCoordinator(parent: self)
        addChild(ccc)
        ccc.start(on: window,
                  moviesRepository: moviesRepository,
                  moviesQueriesRepository: moviesQueriesRepository,
                  posterImagesRepository: posterImagesRepository)
        window.makeKeyAndVisible()
    }
}
