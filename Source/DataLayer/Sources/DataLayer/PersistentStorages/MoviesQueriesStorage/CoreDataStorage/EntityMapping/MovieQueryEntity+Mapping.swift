import Foundation
import CoreData
import DomainLayer

extension MovieQueryEntity {
    convenience init(movieQuery: DomainLayer.MovieQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = movieQuery.query
        createdAt = Date()
    }
}

extension MovieQueryEntity {
    func toDomain() -> DomainLayer.MovieQuery {
        return .init(query: query ?? "")
    }
}
