import Foundation

protocol Coordinating: AnyObject {

    var parent: Coordinating? { get }
    var children: [Coordinating] { get set }

    @discardableResult
    func childDidFinish(_ coordinator: Coordinating) -> Coordinating

    @discardableResult
    func didFinish() -> Coordinating
}

extension Coordinating {

    @discardableResult
    func addChild(_ coordinating: Coordinating) -> Coordinating {
        children.append(coordinating)

        return coordinating
    }

    @discardableResult
    func childDidFinish(_ coordinator: Coordinating) -> Coordinating {
        children = children.filter { $0 !== coordinator }

        return self
    }

    @discardableResult
    func didFinish() -> Coordinating {
        parent?.childDidFinish(self)

        return self
    }
}
