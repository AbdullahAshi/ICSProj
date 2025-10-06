import Foundation
import Combine

@available(iOS 13.0, *)
public protocol Cancellable: Combine.Cancellable {
    func cancel()
}

public final class AppConfiguration {
    public static let apiKey: String = "2696829a81b1b5827d515ff121700838"
    public static let apiBaseURL: String = "http://api.themoviedb.org"
    public static let imagesBaseURL: String = "http://image.tmdb.org"
}
