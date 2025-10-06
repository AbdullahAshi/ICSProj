import Foundation
import DomainLayer

public final class DefaultMoviesQueriesRepository {
    
    private var moviesQueriesPersistentStorage: MoviesQueriesStorage
    
    public init(moviesQueriesPersistentStorage: MoviesQueriesStorage) {
        self.moviesQueriesPersistentStorage = moviesQueriesPersistentStorage
    }
}

extension DefaultMoviesQueriesRepository: DomainLayer.MoviesQueriesRepository {
    
    public func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[DomainLayer.MovieQuery], Error>) -> Void
    ) {
        return moviesQueriesPersistentStorage.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    public func saveRecentQuery(
        query: DomainLayer.MovieQuery,
        completion: @escaping (Result<DomainLayer.MovieQuery, Error>) -> Void
    ) {
        moviesQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
}
