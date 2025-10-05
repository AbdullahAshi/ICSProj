//
//  DIContainer.swift
//  DataLayer
//
//  Created by Abdullah Alashi on 4/10/2025.
//

import Common
import DomainLayer

// Lightweight DI Container based on https://tanaschita.com/dependency-injection-building-lightweight-container/
import Foundation

final class DIContainer: Resolver {
    @MainActor public static let shared = DIContainer()

    private var factories: [String: Any] = [:]
    private var singletons: [String: Any] = [:]
    private var lifetimes: [String: DependencyLifetime] = [:]

    private init() {
        
        // Register services
        register(DomainLayer.DataTransferService.self, factory: {
            DefaultDataTransferService() as! /*any DataTransferServiceProtocol as*/ DataTransferService
        }, lifetime: .transient)
        register(DomainLayer.PosterImagesRepository.self) { DefaultPosterImagesRepository(dataTransferService: <#T##any DataTransferService#>) }
    }

    func register<Service>(_ type: Service.Type, factory: @escaping () -> Service, lifetime: DependencyLifetime) {
        let key = String(describing: type)
        factories[key] = factory
        lifetimes[key] = lifetime
    }

    func resolve<Service>(_ type: Service.Type) -> Service? {
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
