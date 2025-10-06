import Foundation
import DomainLayer
import Common

public final class DefaultPosterImagesRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    public init(dataTransferService: DataTransferService? = nil,
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
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultPosterImagesRepository: DomainLayer.PosterImagesRepository {
    
    public func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> Common.Cancellable? {
        
        let endpoint = APIEndpoints.getMoviePoster(path: imagePath, width: width)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(
            with: endpoint,
            on: backgroundQueue
        ) { (result: Result<Data, DataTransferError>) in

            let result = result.mapError { $0 as Error }
            completion(result)
        }
        return task
    }
}
