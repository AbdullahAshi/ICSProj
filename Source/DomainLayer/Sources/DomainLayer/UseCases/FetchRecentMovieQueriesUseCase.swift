import Foundation
import Combine

// This is another option to create Use Case using more generic way
public final class FetchRecentMovieQueriesUseCase: UseCase {

    public struct RequestValue {
        let maxCount: Int
        
        public init(maxCount: Int) {
            self.maxCount = maxCount
        }
    }
    
    public typealias ResultValue = (Result<[MovieQuery], Error>)

    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let moviesQueriesRepository: MoviesQueriesRepository

    public init(
        requestValue: RequestValue,
        completion: @escaping (ResultValue) -> Void,
        moviesQueriesRepository: MoviesQueriesRepository
    ) {

        self.requestValue = requestValue
        self.completion = completion
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    public func start() -> Cancellable? {

        moviesQueriesRepository.fetchRecentsQueries(
            maxCount: requestValue.maxCount,
            completion: completion
        )
        return nil
    }
}
