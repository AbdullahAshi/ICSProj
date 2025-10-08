import UIKit
import DomainLayer
//import Common
import Combine
//import DataLayer
import SwiftUI

//
//public protocol MoviesSearchFlowCoordinatorDependencies  {
//    func makeMoviesListViewController(
//        actions: MoviesListViewModelActions
//    ) -> MoviesListViewController
//    func makeMoviesDetailsViewController(movie: DomainLayer.Movie) -> UIViewController
//    func makeMoviesQueriesSuggestionsListViewController(
//        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
//    ) -> UIViewController
//}
//
//final class MoviesSearchFlowCoordinator {

//    


//
//    @MainActor private func showMovieQueriesSuggestions(didSelect: @escaping (DomainLayer.MovieQuery) -> Void) {
//        guard let moviesListViewController = moviesListVC, moviesQueriesSuggestionsVC == nil,
//            let container = moviesListViewController.suggestionsListContainer else { return }
//
//        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)
//
//        moviesListViewController.add(child: vc, container: container)
//        moviesQueriesSuggestionsVC = vc
//        container.isHidden = false
//    }
//
//    @MainActor private func closeMovieQueriesSuggestions() {
//        moviesQueriesSuggestionsVC?.remove()
//        moviesQueriesSuggestionsVC = nil
//        moviesListVC?.suggestionsListContainer.isHidden = true
//    }
//}


public final class MoviesSearchCoordinator: Coordinating {

    // MARK: - Properties

    let parent: Coordinating?
    var children: [Coordinating] = []

    private var window: WindowType!
    private let navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialisers

    @MainActor init(parent: Coordinating, navigationController: UINavigationController = UINavigationController()) {
        self.parent = parent
        self.navigationController = navigationController
    }

    // MARK: - Public

    @MainActor public func start(on window: WindowType,
                                 moviesRepository: DomainLayer.MoviesRepository,
                                 moviesQueriesRepository: DomainLayer.MoviesQueriesRepository,
                                 posterImagesRepository: DomainLayer.PosterImagesRepository,
                                 container: DomainLayer.DIContainerDomainLayerProtocol
    ) {
        let defaultSearchMoviesUseCase = DefaultSearchMoviesUseCase(moviesRepository: moviesRepository,
                                                                    moviesQueriesRepository: moviesQueriesRepository
        )
        
        self.window = window
        let viewModel = DefaultMoviesListViewModel(searchMoviesUseCase: defaultSearchMoviesUseCase)
        
        // Handle navigation events from ViewModel
        viewModel.navigationEvents
            .sink { [weak self] event in
                self?.handleNavigationEvent(event, posterImagesRepository: posterImagesRepository, moviesQueriesRepository: moviesQueriesRepository)
            }
            .store(in: &cancellables)
        
        let vc = MoviesListViewController.create(
            with: viewModel,
            posterImagesRepository: posterImagesRepository
        )
        navigationController.pushViewController(vc, animated: true)
        self.window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
    }
    
    @MainActor private func handleNavigationEvent(_ event: DefaultMoviesListViewModel.NavigationEvent,
                                                  posterImagesRepository: DomainLayer.PosterImagesRepository,
                                                  moviesQueriesRepository: DomainLayer.MoviesQueriesRepository) {
            switch event {
            case .showMovieDetails(movie: let movie):
                showMovieDetails(movie: movie, posterImagesRepository: posterImagesRepository)
            case .showMovieQueriesSuggestions(let didSelect):
                showMovieQueriesSuggestions(didSelect: didSelect, moviesQueriesRepository: moviesQueriesRepository)
                break
            case .closeMovieQueriesSuggestions:
//                closeMovieQueriesSuggestions()
                break
            }
        }
    
    @MainActor private func closeMovieQueriesSuggestions() {
        var moviesListViewController = navigationController.children.first as? MoviesListViewController
        moviesListViewController?.remove()
       moviesListViewController = nil
       moviesListViewController?.suggestionsListContainer.isHidden = true
    }
    
    @MainActor private func showMovieDetails(movie: DomainLayer.Movie,
                                             posterImagesRepository: DomainLayer.PosterImagesRepository) {

        let movieDetailsViewController = MovieDetailsViewController.create(
                    with: DefaultMovieDetailsViewModel(
                                    movie: movie,
                                    posterImagesRepository: posterImagesRepository
                                )
                )
        navigationController.pushViewController(movieDetailsViewController, animated: true)
    }
    
    @MainActor private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void,
                                                        moviesQueriesRepository: DomainLayer.MoviesQueriesRepository) {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = MoviesQueryListView(
//                viewModelWrapper: MoviesQueryListViewModelWrapper(
//                    viewModel:  DefaultMoviesQueryListViewModel(
//                        numberOfQueriesToShow: 10,
//                        fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
//                        moviesQueriesRepository: moviesQueriesRepository,
//                        didSelect: didSelect
//                    )
//                )
//            )
//            
//            let vc = UIHostingController(rootView: view)
//            
//            if let moviesListViewController = navigationController.children.first as? MoviesListViewController,
//               let container = moviesListViewController.suggestionsListContainer {
//                moviesListViewController.add(child: vc, container: container)
//                container.isHidden = false
//            }
//        } else { // UIKit
            let vc = MoviesQueriesTableViewController.create(with: DefaultMoviesQueryListViewModel(
                numberOfQueriesToShow: 10,
                //fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
                moviesQueriesRepository: moviesQueriesRepository,
                didSelect: didSelect))
            if let moviesListViewController = navigationController.children.first as? MoviesListViewController,
               let container = moviesListViewController.suggestionsListContainer {
                moviesListViewController.add(child: vc, container: container)
                container.isHidden = false
            }
//        }
    }
    
        func makeFetchRecentMovieQueriesUseCase(
//            requestValue: DomainLayer.FetchRecentMovieQueriesUseCase.RequestValue,
//            completion: @escaping (DomainLayer.FetchRecentMovieQueriesUseCase.ResultValue) -> Void,
            moviesQueriesRepository: MoviesQueriesRepository
        ) -> FetchRecentMovieQueriesUseCase {
            FetchRecentMovieQueriesUseCase(
//                requestValue: requestValue,
//                completion: completion,
                moviesQueriesRepository: moviesQueriesRepository
            )
        }
}
