//
//  NetworkServiceTests.swift
//
//  Created by Abdullah Al-Ashi
//

@testable import ICSProj
import XCTest

class NetworkServiceTests: XCTestCase {
    let anyUrl = URL(string: "https://www.google.com")!
    let mockUrlSession = MockURLSession()
    lazy var networkService = NetworkService(urlSession: { return mockUrlSession })
    
    func testSuccess() throws {
        let response: Response = .init(id: "123451")
        let data: Data = try JSONEncoder().encode(response)
        mockUrlSession.set(mockInfo: (data: data, statusCode: 200, error: nil))
        let expectation = XCTestExpectation(description: "error should be nil, and response shouldn't be nil")
        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .success(let value) = result else {
                return XCTFail("Expected to be a success but got a failure with \(result)")
            }
            XCTAssertEqual(value?.id, "123451")
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testUnsuccessfulStatus() throws {
        mockUrlSession.set(mockInfo: (data: Data(), statusCode: 404, error: nil))
        
        let expectation = XCTestExpectation(description: "error should not be nil, and response should be nil")

        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(let error) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidResponse("unsuccessful status code"))
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testErrorResponse() throws {
        mockUrlSession.set(mockInfo: (data: nil, statusCode: 404, error: NetworkError.unexpectedError))
        
        let expectation = XCTestExpectation(description: "error should not be nil, and response should be nil")

        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(let error) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            XCTAssertEqual(error as! NetworkError, NetworkError.unexpectedError)
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testTimeoutError() throws {
        mockUrlSession.set(mockInfo: (data: nil, statusCode: 404, error: NetworkError.unexpectedError))
        
        let expectation = XCTestExpectation(description: "error timout should occur")

        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(_) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 30, execute: {
                expectation.fulfill()
            })
        })
        let myresult = XCTWaiter().wait(for: [expectation], timeout: 3)
        XCTAssertEqual(myresult, XCTWaiter.Result.timedOut)
    }
    
    func testResponseIsNil() throws {
        mockUrlSession.set(mockInfo: nil)
        
        let expectation = XCTestExpectation(description: "error should not be nil, and response should be nil")

        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(let error) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidResponse("response is nil"))
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testDataIsNil() throws {
        mockUrlSession.set(mockInfo: nil)
        
        let expectation = XCTestExpectation(description: "error should not be nil, and data should be nil")
        mockUrlSession.set(mockInfo: (data: nil, statusCode: 200, error: nil))
        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(let error) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            XCTAssertEqual(error as! NetworkError, NetworkError.invalidResponse("data is nil"))
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
    
    func testDecodingFail() throws {
        struct MalformedResponse: Codable {
            let di: String
        }

        let data: Data = try JSONEncoder().encode(MalformedResponse(di: "123451"))
        let expectation = XCTestExpectation(description: "error should be nil, and response shouldn't be nil")
        
        mockUrlSession.set(mockInfo: (data: data, statusCode: 200, error: nil))
        networkService.get(url: anyUrl, completion: { (result: Result<Response?, Error>) in
            guard case .failure(let error) = result else {
                return XCTFail("Expected to get an error but got a success \(result)")
            }
            XCTAssertEqual(error as! NetworkError, NetworkError.serializationError(error))
            expectation.fulfill()
        })
        self.wait(for: [expectation], timeout: 3.0)
    }
}

// MARK: - Test Model

private extension NetworkServiceTests {

    struct Response: Codable {

        enum CodingKeys: CodingKey {
            case id
        }

        let id: String
    }
}


class MockURLSession: URLSessionProtocol {
    
    typealias MockInfo = (data: Data?, statusCode: Int, error: Error?)
    
    private(set) var nextDataTask = MockURLSessionDataTask()
    private var mockInfo: MockInfo?
    
    private var mockResponse: HTTPURLResponse {
        return HTTPURLResponse(url: URL(string: "https://www.google.com")!, statusCode: mockInfo!.statusCode, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with url: URL, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        nextDataTask.resume()
        if let mockInfo = mockInfo {
            completionHandler(mockInfo.data, mockResponse, mockInfo.error)
        } else {
            completionHandler(Data(), nil, nil)
        }
        return nextDataTask
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        nextDataTask.resume()
        if let mockInfo = mockInfo {
            completionHandler(mockInfo.data, mockResponse, mockInfo.error)
        } else {
            completionHandler(Data(), nil, nil)
        }
        return nextDataTask
    }
    
    
    func set(mockInfo: MockInfo?) {
        self.mockInfo = mockInfo
    }
    
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeCalled = false
    
    func resume() {
        resumeCalled = true
    }
    
    func cancel() {
    }
}

extension URLResponse {
    static func mock(url: URL = URL(string: "https://www.google.com")!,
                     statusCode: Int = 200,
                     httpVersion: String? = nil,
                     headerFields: [String: String]? = nil) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: httpVersion, headerFields: headerFields)!
    }
}
