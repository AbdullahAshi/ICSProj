import Foundation
import DomainLayer
import Common

final class UserDefaultsMoviesQueriesStorage {
    private let maxStorageLimit: Int
    private let recentsMoviesQueriesKey = "recentsMoviesQueries"
    private var userDefaults: UserDefaults
    private let backgroundQueue: Common.DispatchQueueType
    
    init(
        maxStorageLimit: Int,
        userDefaults: UserDefaults = UserDefaults.standard,
        backgroundQueue: Common.DispatchQueueType = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.maxStorageLimit = maxStorageLimit
        self.userDefaults = userDefaults
        self.backgroundQueue = backgroundQueue
    }

    private func fetchMoviesQueries() -> [DomainLayer.MovieQuery] {
        if let queriesData = userDefaults.object(forKey: recentsMoviesQueriesKey) as? Data {
            if let movieQueryList = try? JSONDecoder().decode(MovieQueriesListUDS.self, from: queriesData) {
                return movieQueryList.list.map { $0.toDomain() }
            }
        }
        return []
    }

    private func persist(moviesQueries: [DomainLayer.MovieQuery]) {
        let encoder = JSONEncoder()
        let movieQueryUDSs = moviesQueries.map(MovieQueryUDS.init)
        if let encoded = try? encoder.encode(MovieQueriesListUDS(list: movieQueryUDSs)) {
            userDefaults.set(encoded, forKey: recentsMoviesQueriesKey)
        }
    }
}

extension UserDefaultsMoviesQueriesStorage: MoviesQueriesStorage {

    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[DomainLayer.MovieQuery], Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchMoviesQueries()
            queries = queries.count < self.maxStorageLimit ? queries : Array(queries[0..<maxCount])
            completion(.success(queries))
        }
    }

    func saveRecentQuery(
        query: DomainLayer.MovieQuery,
        completion: @escaping (Result<DomainLayer.MovieQuery, Error>) -> Void
    ) {
        backgroundQueue.async { [weak self] in
            guard let self = self else { return }

            var queries = self.fetchMoviesQueries()
            self.cleanUpQueries(for: query, in: &queries)
            queries.insert(query, at: 0)
            self.persist(moviesQueries: queries)

            completion(.success(query))
        }
    }
}


// MARK: - Private
extension UserDefaultsMoviesQueriesStorage {

    private func cleanUpQueries(for query: DomainLayer.MovieQuery, in queries: inout [DomainLayer.MovieQuery]) {
        removeDuplicates(for: query, in: &queries)
        removeQueries(limit: maxStorageLimit - 1, in: &queries)
    }

    private func removeDuplicates(for query: DomainLayer.MovieQuery, in queries: inout [DomainLayer.MovieQuery]) {
        queries = queries.filter { $0 != query }
    }

    private func removeQueries(limit: Int, in queries: inout [DomainLayer.MovieQuery]) {
        queries = queries.count <= limit ? queries : Array(queries[0..<limit])
    }
}
