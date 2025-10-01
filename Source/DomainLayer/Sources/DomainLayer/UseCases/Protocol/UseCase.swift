import Foundation
import Combine

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
