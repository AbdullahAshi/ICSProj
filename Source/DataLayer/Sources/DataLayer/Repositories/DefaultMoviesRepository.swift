// **Note**: DTOs structs are mapped into Domains here, and Repository protocols does not contain DTOs

import Foundation
import DomainLayer
import Common

public final class DefaultMoviesRepository: DomainLayer.MoviesRepository {
    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage
    private let backgroundQueue: DataTransferDispatchQueue

    public init(
        dataTransferService: DataTransferService? = nil,
        cache: MoviesResponseStorage = CoreDataMoviesResponseStorage(),
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        if let dataTransferService = dataTransferService {
            self.dataTransferService = dataTransferService
        } else {
            let config = ApiDataNetworkConfig(
                baseURL: URL(string: AppConfiguration.apiBaseURL)!,
                queryParameters: [
                    "api_key": AppConfiguration.apiKey,
                    "language": NSLocale.preferredLanguages.first ?? "en"
                ]
            )
            
            let apiDataNetwork = DefaultNetworkService(config: config)
            self.dataTransferService = DefaultDataTransferService(with: apiDataNetwork)
        }
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
    
//    public func fetchMoviesList(
//        query: DomainLayer.MovieQuery,
//        page: Int,
//        cached: @escaping (DomainLayer.MoviesPage) -> Void,
//        completion: @escaping (Result<DomainLayer.MoviesPage, Error>) -> Void
//    ) -> Common.Cancellable? {
    public func fetchMoviesList(query: DomainLayer.MovieQuery, page: Int, cached: @escaping (DomainLayer.MoviesPage) -> Void, completion: @escaping (Result<DomainLayer.MoviesPage, Error>) -> Void) -> ( Common.Cancellable)? {
        let requestDTO = MoviesRequestDTO(query: query.query, page: page)
        let task = RepositoryTask()

//        cache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
//
//            if case let .success(responseDTO?) = result {
//                cached(responseDTO.toDomain())
//            }
            guard !task.isCancelled else { return nil }

            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            task.networkTask = self/*?*/.dataTransferService.request(
                with: endpoint,
                on: backgroundQueue
            ) { result in
                switch result {
                case .success(let responseDTO):
//                    self?.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
//        }
        return task
    }
}
