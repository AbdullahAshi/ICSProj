import Foundation
import DomainLayer

public protocol MoviesQueriesStorage {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[DomainLayer.MovieQuery], Error>) -> Void
    )
    func saveRecentQuery(
        query: DomainLayer.MovieQuery,
        completion: @escaping (Result<DomainLayer.MovieQuery, Error>) -> Void
    )
}
