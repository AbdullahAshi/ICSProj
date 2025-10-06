import Foundation

public struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
    
    public init(query: String, page: Int) {
        self.query = query
        self.page = page
    }
}
