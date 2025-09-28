import XCTest
import Combine

class MovieDetailsViewModelTests: XCTestCase {
    
    private enum PosterImageDownloadError: Error {
        case someError
    }
    
    func test_updatePosterImageWithWidthEventReceived_thenImageWithThisWidthIsDownloaded() {
        // given
        let posterImagesRepository = PosterImagesRepositoryMock()

        let expectedImage = "image data".data(using: .utf8)!
        posterImagesRepository.image = expectedImage

        let viewModel = DefaultMovieDetailsViewModel(
            movie: Movie.stub(posterPath: "posterPath"),
            posterImagesRepository: posterImagesRepository,
            mainQueue: DispatchQueueTypeMock()
        )
        
        posterImagesRepository.validateInput = { (imagePath: String, width: Int) in
            XCTAssertEqual(imagePath, "posterPath")
            XCTAssertEqual(width, 200)
        }
        
        // when
        viewModel.updatePosterImage(width: 200)
        
        // then
        let expectation = XCTestExpectation(description: "Poster image should be updated")
        var receivedImage: Data?
        
        let cancellable = viewModel.posterImage
            .sink { image in
                receivedImage = image
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedImage, expectedImage)
        XCTAssertEqual(posterImagesRepository.completionCalls, 1)
        
        // Clean up
        cancellable.cancel()
    }
}
