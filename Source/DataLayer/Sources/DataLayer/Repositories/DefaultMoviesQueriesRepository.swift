import Foundation

final class DefaultMoviesQueriesRepository {
    
    private var moviesQueriesPersistentStorage: MoviesQueriesStorage
    
    init(moviesQueriesPersistentStorage: MoviesQueriesStorage) {
        self.moviesQueriesPersistentStorage = moviesQueriesPersistentStorage
    }
}

extension DefaultMoviesQueriesRepository: DomainLayer.MoviesQueriesRepository {
    
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[DomainLayer.MovieQuery], Error>) -> Void
    ) {
        return moviesQueriesPersistentStorage.fetchRecentsQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    func saveRecentQuery(
        query: DomainLayer.MovieQuery,
        completion: @escaping (Result<DomainLayer.MovieQuery, Error>) -> Void
    ) {
        moviesQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
}
