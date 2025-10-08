import Foundation
import Combine
import DomainLayer
import Common

public typealias MoviesQueryListViewModelDidSelectAction = (DomainLayer.MovieQuery) -> Void

protocol MoviesQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: MoviesQueryListItemViewModel)
}

protocol MoviesQueryListViewModelOutput {
    var items: AnyPublisher<[MoviesQueryListItemViewModel], Never> { get }
}

protocol MoviesQueryListViewModel: MoviesQueryListViewModelInput, MoviesQueryListViewModelOutput { }

//typealias FetchRecentMovieQueriesUseCaseFactory = (DomainLayer.FetchRecentMovieQueriesUseCase.RequestValue,
//    @escaping (DomainLayer.FetchRecentMovieQueriesUseCase.ResultValue) -> Void,
//                                                   MoviesQueriesRepository) -> DomainLayer.UseCase

final class DefaultMoviesQueryListViewModel: MoviesQueryListViewModel {

    private let numberOfQueriesToShow: Int
//    private let fetchRecentMovieQueriesUseCaseFactory: FetchRecentMovieQueriesUseCaseFactory
    private let didSelect: MoviesQueryListViewModelDidSelectAction?
    private let mainQueue: Common.DispatchQueueType
    private let moviesQueriesRepository: MoviesQueriesRepository
    
    // MARK: - OUTPUT
    private let itemsSubject = CurrentValueSubject<[MoviesQueryListItemViewModel], Never>([])
    var items: AnyPublisher<[MoviesQueryListItemViewModel], Never> { itemsSubject.eraseToAnyPublisher() }
    
    init(
        numberOfQueriesToShow: Int,
//        fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory,
        moviesQueriesRepository: MoviesQueriesRepository,
        didSelect: MoviesQueryListViewModelDidSelectAction? = nil,
        mainQueue: Common.DispatchQueueType = DispatchQueue.main
    ) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
//        self.fetchRecentMovieQueriesUseCaseFactory = fetchRecentMovieQueriesUseCaseFactory
        self.didSelect = didSelect
        self.mainQueue = mainQueue
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    private func updateMoviesQueries() {
//        let request = DomainLayer.FetchRecentMovieQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
//        let completion: (DomainLayer.FetchRecentMovieQueriesUseCase.ResultValue) -> Void = { [weak self] result in
//            self?.mainQueue.async {
//                switch result {
//                case .success(let items):
//                    self?.itemsSubject.send(items
//                        .map { $0.query }
//                        .map(MoviesQueryListItemViewModel.init))
//                case .failure:
//                    break
//                }
//            }
//        }
//        let useCase = fetchRecentMovieQueriesUseCaseFactory(request, completion, moviesQueriesRepository)
//        useCase.start()
    }
}

// MARK: - INPUT. View event methods
extension DefaultMoviesQueryListViewModel {
        
    func viewWillAppear() {
        updateMoviesQueries()
    }
    
    func didSelect(item: MoviesQueryListItemViewModel) {
        didSelect?(DomainLayer.MovieQuery(query: item.query))
    }
}
