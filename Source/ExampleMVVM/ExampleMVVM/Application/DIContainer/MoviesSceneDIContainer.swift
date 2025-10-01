//import UIKit
//import SwiftUI
//import DomainLayer
//import PresentationLayer
//
//final class MoviesSceneDIContainer: MoviesSearchFlowCoordinatorDependencies {
//    
//    struct Dependencies {
//        let apiDataTransferService: DataTransferService
//        let imageDataTransferService: DataTransferService
//    }
//    
//    private let dependencies: Dependencies
//
//    // MARK: - Persistent Storage
//    lazy var moviesQueriesStorage: MoviesQueriesStorage = CoreDataMoviesQueriesStorage(maxStorageLimit: 10)
//    lazy var moviesResponseCache: MoviesResponseStorage = CoreDataMoviesResponseStorage()
//
//    init(dependencies: Dependencies) {
//        self.dependencies = dependencies        
//    }
//    
//    // MARK: - Use Cases
//    func makeSearchMoviesUseCase() -> DomainLayer.SearchMoviesUseCase {
//        DefaultSearchMoviesUseCase(
//            moviesRepository: makeMoviesRepository(),
//            moviesQueriesRepository: makeMoviesQueriesRepository()
//        )
//    }
//    
//    func makeFetchRecentMovieQueriesUseCase(
//        requestValue: DomainLayer.FetchRecentMovieQueriesUseCase.RequestValue,
//        completion: @escaping (DomainLayer.FetchRecentMovieQueriesUseCase.ResultValue) -> Void
//    ) -> UseCase {
//        FetchRecentMovieQueriesUseCase(
//            requestValue: requestValue,
//            completion: completion,
//            moviesQueriesRepository: makeMoviesQueriesRepository()
//        )
//    }
//    
//    // MARK: - Repositories
//    func makeMoviesRepository() -> DomainLayer.MoviesRepository {
//        DefaultMoviesRepository(
//            dataTransferService: dependencies.apiDataTransferService,
//            cache: moviesResponseCache
//        )
//    }
//    func makeMoviesQueriesRepository() -> DomainLayer.MoviesQueriesRepository {
//        DefaultMoviesQueriesRepository(
//            moviesQueriesPersistentStorage: moviesQueriesStorage
//        )
//    }
//    func makePosterImagesRepository() -> DomainLayer.PosterImagesRepository {
//        DefaultPosterImagesRepository(
//            dataTransferService: dependencies.imageDataTransferService
//        )
//    }
//    
//    // MARK: - Movies List
//    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController {
//        MoviesListViewController.create(
//            with: makeMoviesListViewModel(actions: actions),
//            posterImagesRepository: makePosterImagesRepository()
//        )
//    }
//    
//    func makeMoviesListViewModel(actions: MoviesListViewModelActions) -> MoviesListViewModel {
//        DefaultMoviesListViewModel(
//            searchMoviesUseCase: makeSearchMoviesUseCase(),
//            actions: actions
//        )
//    }
//    
//    // MARK: - Movie Details
//    func makeMoviesDetailsViewController(movie: DomainLayer.Movie) -> UIViewController {
//        MovieDetailsViewController.create(
//            with: makeMoviesDetailsViewModel(movie: movie)
//        )
//    }
//    
//    func makeMoviesDetailsViewModel(movie: DomainLayer.Movie) -> MovieDetailsViewModel {
//        DefaultMovieDetailsViewModel(
//            movie: movie,
//            posterImagesRepository: makePosterImagesRepository()
//        )
//    }
//    
//    // MARK: - Movies Queries Suggestions List
//    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController {
//        if #available(iOS 13.0, *) { // SwiftUI
//            let view = MoviesQueryListView(
//                viewModelWrapper: makeMoviesQueryListViewModelWrapper(didSelect: didSelect)
//            )
//            return UIHostingController(rootView: view)
//        } else { // UIKit
//            return MoviesQueriesTableViewController.create(
//                with: makeMoviesQueryListViewModel(didSelect: didSelect)
//            )
//        }
//    }
//    
//    func makeMoviesQueryListViewModel(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> MoviesQueryListViewModel {
//        DefaultMoviesQueryListViewModel(
//            numberOfQueriesToShow: 10,
//            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase,
//            didSelect: didSelect
//        )
//    }
//
//    @available(iOS 13.0, *)
//    func makeMoviesQueryListViewModelWrapper(
//        didSelect: @escaping MoviesQueryListViewModelDidSelectAction
//    ) -> MoviesQueryListViewModelWrapper {
//        MoviesQueryListViewModelWrapper(
//            viewModel: makeMoviesQueryListViewModel(didSelect: didSelect)
//        )
//    }
//
//    // MARK: - Flow Coordinators
//    func makeMoviesSearchFlowCoordinator(navigationController: UINavigationController) -> MoviesSearchFlowCoordinator {
//        MoviesSearchFlowCoordinator(
//            navigationController: navigationController,
//            dependencies: self
//        )
//    }
//}
