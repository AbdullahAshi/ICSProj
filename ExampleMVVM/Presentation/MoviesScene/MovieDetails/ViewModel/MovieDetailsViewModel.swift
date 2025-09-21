import Foundation
import Combine

protocol MovieDetailsViewModelInput {
    func updatePosterImage(width: Int)
}

protocol MovieDetailsViewModelOutput {
    var title: String { get }
    var posterImage: AnyPublisher<Data?, Never> { get }
    var isPosterImageHidden: Bool { get }
    var overview: String { get }
}

protocol MovieDetailsViewModel: MovieDetailsViewModelInput, MovieDetailsViewModelOutput { }

final class DefaultMovieDetailsViewModel: MovieDetailsViewModel {
    
    private let posterImagePath: String?
    private let posterImagesRepository: PosterImagesRepository
    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }
    private let mainQueue: DispatchQueueType

    // MARK: - OUTPUT
    let title: String
    private let posterImageSubject = CurrentValueSubject<Data?, Never>(nil)
    var posterImage: AnyPublisher<Data?, Never> { posterImageSubject.eraseToAnyPublisher() }
    let isPosterImageHidden: Bool
    let overview: String
    
    init(
        movie: Movie,
        posterImagesRepository: PosterImagesRepository,
        mainQueue: DispatchQueueType = DispatchQueue.main
    ) {
        self.title = movie.title ?? ""
        self.overview = movie.overview ?? ""
        self.posterImagePath = movie.posterPath
        self.isPosterImageHidden = movie.posterPath == nil
        self.posterImagesRepository = posterImagesRepository
        self.mainQueue = mainQueue
    }
}

// MARK: - INPUT. View event methods
extension DefaultMovieDetailsViewModel {
    
    func updatePosterImage(width: Int) {
        guard let posterImagePath = posterImagePath else { return }

        imageLoadTask = posterImagesRepository.fetchImage(
            with: posterImagePath,
            width: width
        ) { [weak self] result in
            self?.mainQueue.async {
                guard self?.posterImagePath == posterImagePath else { return }
                switch result {
                case .success(let data):
                    self?.posterImageSubject.send(data)
                case .failure: break
                }
                self?.imageLoadTask = nil
            }
        }
    }
}
