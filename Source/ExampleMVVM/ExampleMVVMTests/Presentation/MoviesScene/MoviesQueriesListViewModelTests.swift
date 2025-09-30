@testable import ExampleMVVM
import XCTest
import Combine

class MoviesQueriesListViewModelTests: XCTestCase {
    
    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var movieQueries = [MovieQuery(query: "query1"),
                        MovieQuery(query: "query2"),
                        MovieQuery(query: "query3"),
                        MovieQuery(query: "query4"),
                        MovieQuery(query: "query5")]

    class FetchRecentMovieQueriesUseCaseMock: UseCase {
        var startCalledCount: Int = 0
        var error: Error?
        var movieQueries: [MovieQuery] = []
        var completion: (Result<[MovieQuery], Error>) -> Void = { _ in }

        func start() -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(movieQueries))
            }
            startCalledCount += 1
            return nil
        }
    }

    func makeFetchRecentMovieQueriesUseCase(_ mock: FetchRecentMovieQueriesUseCaseMock) -> FetchRecentMovieQueriesUseCaseFactory {
        return { _, completion in
            mock.completion = completion
            return mock
        }
    }
    
    // MARK: - Helper Methods
    
    private func expectPublisher<T>(
        _ publisher: AnyPublisher<[T], Never>,
        toReceive expectedValue: [T],
        timeout: TimeInterval = 1.0,
        file: StaticString = #file,
        line: UInt = #line
    ) where T: Equatable {
        let expectation = XCTestExpectation(description: "Publisher should emit expected value")
        var receivedValue: [T]?
        
        let cancellable = publisher
            .sink { value in
                receivedValue = value
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
        cancellable.cancel()
    }
    
    private func expectPublisherToBeEmpty<T>(
        _ publisher: AnyPublisher<[T], Never>,
        timeout: TimeInterval = 1.0,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = XCTestExpectation(description: "Publisher should emit empty array")
        var receivedValue: [T]?
        
        let cancellable = publisher
            .sink { value in
                receivedValue = value
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: timeout)
        XCTAssertTrue(receivedValue?.isEmpty ?? false, file: file, line: line)
        cancellable.cancel()
    }
    
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentMovieQueriesUseCaseMock()
        useCase.movieQueries = movieQueries
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(useCase)
        )

        // when
        viewModel.viewWillAppear()
        
        // then
        let expectedItems = movieQueries.map { MoviesQueryListItemViewModel(query: $0.query) }
        expectPublisher(viewModel.items, toReceive: expectedItems)
        XCTAssertEqual(useCase.startCalledCount, 1)
    }
    
    func test_whenFetchRecentMovieQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentMovieQueriesUseCaseMock()
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(useCase)
        )
        
        // when
        viewModel.viewWillAppear()
        
        // then
        expectPublisherToBeEmpty(viewModel.items)
        XCTAssertEqual(useCase.startCalledCount, 1)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenCallDidSelectAction() {
        // given
        let selectedQueryItem = MovieQuery(query: "query1")
        var actionMovieQuery: MovieQuery?
        var delegateNotifiedCount = 0
        let didSelect: MoviesQueryListViewModelDidSelectAction = { movieQuery in
            actionMovieQuery = movieQuery
            delegateNotifiedCount += 1
        }
        
        let viewModel = DefaultMoviesQueryListViewModel.make(
            numberOfQueriesToShow: 3,
            fetchRecentMovieQueriesUseCaseFactory: makeFetchRecentMovieQueriesUseCase(FetchRecentMovieQueriesUseCaseMock()),
            didSelect: didSelect
        )
        
        // when
        viewModel.didSelect(item: MoviesQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        XCTAssertEqual(actionMovieQuery, selectedQueryItem)
        XCTAssertEqual(delegateNotifiedCount, 1)
    }
}

extension DefaultMoviesQueryListViewModel {
    static func make(
        numberOfQueriesToShow: Int,
        fetchRecentMovieQueriesUseCaseFactory: @escaping FetchRecentMovieQueriesUseCaseFactory,
        didSelect: MoviesQueryListViewModelDidSelectAction? = nil
    ) -> DefaultMoviesQueryListViewModel {
        DefaultMoviesQueryListViewModel(
            numberOfQueriesToShow: numberOfQueriesToShow,
            fetchRecentMovieQueriesUseCaseFactory: fetchRecentMovieQueriesUseCaseFactory,
            didSelect: didSelect,
            mainQueue: DispatchQueueTypeMock()
        )
    }
}
