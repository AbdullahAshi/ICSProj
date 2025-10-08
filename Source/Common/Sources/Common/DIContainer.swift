//
//  DIContainer.swift
//  Common
//
//  Created by Abdullah Alashi on 4/10/2025.
//


public enum DependencyLifetime {
    case singleton
    case transient
}

public protocol Resolver {
    func resolve<T>(_ type: T.Type) -> T?
}

@propertyWrapper
public struct Injected<Service> {
    private var dependency: Service

    public init(resolver: Resolver) {
        guard let dependency = resolver.resolve(Service.self) else {
            fatalError("No dependency registered for \(Service.self)")
        }
        self.dependency = dependency
    }

    public var wrappedValue: Service {
        dependency
    }
}


// Lightweight DI Container based on https://tanaschita.com/dependency-injection-building-lightweight-container/
import Foundation

public final class DIContainer: Resolver {
//    @MainActor public static let shared = DIContainer()

    private var factories: [String: Any] = [:]
    private var singletons: [String: Any] = [:]
    private var lifetimes: [String: DependencyLifetime] = [:]

    public init() {}

    public func register<Service>(_ type: Service.Type, factory: @escaping () -> Service, lifetime: DependencyLifetime) {
        let key = String(describing: type)
        factories[key] = factory
        lifetimes[key] = lifetime
    }

    public func resolve<Service>(_ type: Service.Type) -> Service? {
        let key = String(describing: type)
        guard let lifetime = lifetimes[key] else {
            return nil
        }

        switch lifetime {
        case .transient:
            guard let factory = factories[key] as? () -> Service else {
                return nil
            }
            return factory()
        case .singleton:
            if let instance = singletons[key] as? Service {
                return instance
            }
            guard let factory = factories[key] as? () -> Service else {
                return nil
            }
            let instance = factory()
            singletons[key] = instance
            return instance
        }
    }
}
