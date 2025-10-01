import Foundation
import Combine

@available(iOS 13.0, *)
public protocol Cancellable: Combine.Cancellable {
    func cancel()
}
