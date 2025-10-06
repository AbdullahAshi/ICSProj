import Foundation
import DomainLayer
import Combine

// MARK: - Data Transfer Object

public struct MoviesResponseDTO: Decodable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
    
    public init(page: Int, totalPages: Int, movies: [MovieDTO]) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}

extension MoviesResponseDTO {
    public struct MovieDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case genre
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
        }
        public enum GenreDTO: String, Decodable {
            case adventure
            case scienceFiction = "science_fiction"
        }
        let id: Int
        let title: String?
        let genre: GenreDTO?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
        
        public init(id: Int, title: String?, genre: GenreDTO?, posterPath: String?, overview: String?, releaseDate: String?) {
            self.id = id
            self.title = title
            self.genre = genre
            self.posterPath = posterPath
            self.overview = overview
            self.releaseDate = releaseDate
        }
    }
}

// MARK: - Mappings to Domain

extension MoviesResponseDTO {
    func toDomain() -> DomainLayer.MoviesPage {
        return DomainLayer.MoviesPage(page: page,
                                      totalPages: totalPages,
                                      movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toDomain() -> DomainLayer.Movie {
        return DomainLayer.Movie(id: Movie.Identifier(id),
                     title: title,
                     genre: genre?.toDomain(),
                     posterPath: posterPath,
                     overview: overview,
                     releaseDate: dateFormatter.date(from: releaseDate ?? ""))
    }
}

extension MoviesResponseDTO.MovieDTO.GenreDTO {
    func toDomain() -> DomainLayer.Movie.Genre {
        switch self {
        case .adventure: return .adventure
        case .scienceFiction: return .scienceFiction
        }
    }
}

// MARK: - Private

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
}()
