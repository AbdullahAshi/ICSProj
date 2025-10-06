import UIKit
import DomainLayer
//import Common
//import Combine
//import DataLayer
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
//    private weak var navigationController: UINavigationController?
//    private let dependencies: MoviesSearchFlowCoordinatorDependencies
//
//    private weak var moviesListVC: MoviesListViewController?
//    private weak var moviesQueriesSuggestionsVC: UIViewController?
//
//    init(navigationController: UINavigationController,
//         dependencies: MoviesSearchFlowCoordinatorDependencies) {
//        self.navigationController = navigationController
//        self.dependencies = dependencies
//    }
//    
//    @MainActor func start() {
//        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
//        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails,
//                                                 showMovieQueriesSuggestions: showMovieQueriesSuggestions,
//                                                 closeMovieQueriesSuggestions: closeMovieQueriesSuggestions)
//        let vc = dependencies.makeMoviesListViewController(actions: actions)
//
//        navigationController?.pushViewController(vc, animated: false)
//        moviesListVC = vc
//    }
//
//    @MainActor private func showMovieDetails(movie: DomainLayer.Movie) {
//        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
//        navigationController?.pushViewController(vc, animated: true)
//    }
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

    // MARK: - Initialisers

    @MainActor init(parent: Coordinating, navigationController: UINavigationController = UINavigationController()) {
        self.parent = parent
        self.navigationController = navigationController
    }

    // MARK: - Public

    @MainActor public func start(on window: WindowType,
                                 moviesRepository: DomainLayer.MoviesRepository,
                                 moviesQueriesRepository: DomainLayer.MoviesQueriesRepository,
                                 posterImagesRepository: DomainLayer.PosterImagesRepository
    ) {
        let defaultSearchMoviesUseCase = DefaultSearchMoviesUseCase(moviesRepository: moviesRepository,
                                                                    moviesQueriesRepository: moviesQueriesRepository /*DataLayer.DefaultMoviesRepository() as! MoviesQueriesRepository*/
        )
        
        self.window = window
        let vc = MoviesListViewController.create(
            with: DefaultMoviesListViewModel(searchMoviesUseCase: defaultSearchMoviesUseCase) ,
            posterImagesRepository: posterImagesRepository //DataLayer.DefaultPosterImagesRepository()
        )
        navigationController.pushViewController(vc, animated: true)
        self.window.rootViewController = self.navigationController
        window.makeKeyAndVisible()
        DispatchQueue.main.async {
            
        }
    }
}
