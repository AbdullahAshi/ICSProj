import Foundation
import DomainLayer
import Common

public final class DefaultPosterImagesRepository {
    
    private let dataTransferService: DataTransferService
    private let backgroundQueue: DataTransferDispatchQueue

    public init(dataTransferService: DataTransferService,
        backgroundQueue: DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
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
