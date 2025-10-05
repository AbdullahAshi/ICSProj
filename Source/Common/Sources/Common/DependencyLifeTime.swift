//
//  DependencyLifeTime.swift
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


