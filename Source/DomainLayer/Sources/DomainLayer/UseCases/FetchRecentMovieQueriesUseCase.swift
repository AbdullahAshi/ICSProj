import Foundation
import Combine

// This is another option to create Use Case using more generic way
public final class FetchRecentMovieQueriesUseCase {

    private let moviesQueriesRepository: MoviesQueriesRepository

    public init(moviesQueriesRepository: MoviesQueriesRepository) {
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    public func fetchRecentsQueries(maxCount: Int, completion: @escaping ((Result<[MovieQuery], Error>) -> Void)) -> Cancellable? {

        moviesQueriesRepository.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
        return nil
    }
}
