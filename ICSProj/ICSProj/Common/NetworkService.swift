//
//  NetworkService.swift
//  ICSProj
//
//  Created by Abdullah Alashi on 17/9/2025.
//

import Foundation

//MARK: - URLSession

typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

protocol URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return ( dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return ( dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

enum NetworkError: Error, Equatable {
    case invalidResponse(String)
    case serializationError(Error)
    case unexpectedError
    
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidResponse(let lhsMessage), .invalidResponse(let rhsMessage)):
            return lhsMessage == rhsMessage
            
        case (.serializationError(_), .serializationError(_)):
            return true
            
        case (.unexpectedError, .unexpectedError):
            return true
            
        default:
            return false
        }
    }
}


//MARK: - NetworkService

typealias NetworkCompletionHandler<Model: Codable> = (Result<Model?,Error>) -> Void

protocol NetworkServiceProtocol {
    @discardableResult
    func get<Model: Codable>(url: URL, completion: @escaping NetworkCompletionHandler<Model>) -> URLSessionDataTaskProtocol
}


final class NetworkService: NetworkServiceProtocol {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private let urlSession: URLSessionProtocol
    
    static let shared: NetworkServiceProtocol = NetworkService()
    
    //exposed for unit tests
    init(urlSession: () -> URLSessionProtocol = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad
        sessionConfig.urlCache = URLCache(memoryCapacity: 40 * 1024 * 1024,
                                        diskCapacity: 512 * 1024 * 1024,
                                        diskPath: "urlCache")
        return URLSession(configuration: sessionConfig)
    }) {
        self.urlSession = urlSession()
    }
    
    @discardableResult
    func get<Model: Codable>(url: URL, completion: @escaping NetworkCompletionHandler<Model>) -> URLSessionDataTaskProtocol {
        return request(url: url, method: .get, completion: completion)
    }
    
    private func request<Model: Codable>(url: URL,
                                       method: HttpMethod,
                                       completion: @escaping NetworkCompletionHandler<Model>) -> URLSessionDataTaskProtocol {
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            guard let response = (response as? HTTPURLResponse) else {
                completion(.failure(NetworkError.invalidResponse("response is nil")))
                return
            }
            
            guard  200..<399 ~= response.statusCode else {
                completion(.failure(NetworkError.invalidResponse("unsuccessful status code")))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse("data is nil")))
                return
            }
            
            do {
                let object = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(object))
            } catch {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    print(json ?? ["": ""])
                } catch {
                    print(error)
                }
                completion(.failure(NetworkError.serializationError(error)))
            }
        }
        task.resume()
        return task
    }
    
}

