import Foundation
import Combine

typealias MoviesQueryListViewModelDidSelectAction = (MovieQuery) -> Void

protocol MoviesQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: MoviesQueryListItemViewModel)
}

protocol MoviesQueryListViewModelOutput {
    var items: AnyPublisher<[MoviesQueryListItemViewModel], Never> { get }
}

protocol MoviesQueryListViewModel: MoviesQueryListViewModelInput, MoviesQueryListViewModelOutput { }

typealias FetchRecentMovieQueriesUseCaseFactory = (
    FetchRecentMovieQueriesUseCase.RequestValue,
    @escaping (FetchRecentMovieQueriesUseCase.ResultValue) -> Void
) -> UseCase

final class DefaultMoviesQueryListViewModel: MoviesQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentMovieQueriesUseCaseFactory: FetchRecentMovieQueriesUseCaseFactory
    private let didSelect: MoviesQueryListViewModelDidSelectAction?
    private let mainQueue: DispatchQueueType
    
    // MARK: - OUTPUT
    private let itemsSubject = CurrentValueSubject<[MoviesQueryListItemViewModel], Never>([])
    var items: AnyPublisher<[MoviesQueryListItemViewModel], Never> { itemsSubject.eraseToAnyPublisher() }
    
    init(
        numberOfQueriesToShow: Int,
        fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory,
        didSelect: MoviesQueryListViewModelDidSelectAction? = nil,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentMovieQueriesUseCaseFactory = fetchRecentMovieQueriesUseCaseFactory
        self.didSelect = didSelect
        self.mainQueue = mainQueue
    }
    
    private func updateMoviesQueries() {
        let request = FetchRecentMovieQueriesUseCase.RequestValue(maxCount: numberOfQueriesToShow)
        let completion: (FetchRecentMovieQueriesUseCase.ResultValue) -> Void = { [weak self] result in
            self?.mainQueue.async {
                switch result {
                case .success(let items):
                    self?.itemsSubject.send(items
                        .map { $0.query }
                        .map(MoviesQueryListItemViewModel.init))
                case .failure:
                    break
                }
            }
        }
        let useCase = fetchRecentMovieQueriesUseCaseFactory(request, completion)
        useCase.start()
    }
}

// MARK: - INPUT. View event methods
extension DefaultMoviesQueryListViewModel {
        
    func viewWillAppear() {
        updateMoviesQueries()
    }
    
    func didSelect(item: MoviesQueryListItemViewModel) {
        didSelect?(MovieQuery(query: item.query))
    }
}
