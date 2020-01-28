//
//  NetworkingServiceSpec.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

@testable import DonutView
import Nimble
import Quick

class NetworkingServiceSpec: QuickSpec {
    var service: NetworkingService!
    
    override func spec() {
        describe("NetworkingService Spec") {
            
            context("Success path") {
                it("successfuly fetch credit") {
                    let jsonEncoder = JSONEncoder()
                    let expectResult: Credit = Credit.fakeCredit!
                    
                    let stubbedURLResponse = HTTPURLResponse(url: URL(string: "https://fake.url.co.uk")!,
                                                             statusCode: 200,
                                                             httpVersion: nil,
                                                             headerFields: nil)
                    let stubbedData = Metadata(creditReportInfo: expectResult)
                    let urlSession = MockURLSession()
                    urlSession.stubbedURLResponse = stubbedURLResponse
                    urlSession.stubbedData = try? jsonEncoder.encode(stubbedData)
                    
                    let service = NetworkingService()
                    service.session = urlSession
                    
                    var actualResult: Credit?
                    service.credit { result in
                                    switch result {
                                    case let .success(credit): actualResult = credit
                                    case .failure: XCTFail("Credit request shouldn't fail")
                                    }
                    }
                    
                    expect(actualResult).toEventually(equal(expectResult))
                }
            }
            
            context("Fail path") {
                it("recevies invalid request error") {
                    let jsonEncoder = JSONEncoder()
                    let urlPath = URL(string: "https://fake.url.co.uk")!
                    let expectResult: NetworkingServiceError = .invalidRequest
                    
                    let stubbedURLResponse = HTTPURLResponse(url: urlPath,
                                                             statusCode: 404,
                                                             httpVersion: nil,
                                                             headerFields: nil)
                    let stubbedData = Metadata(creditReportInfo: Credit.fakeCredit!)
                    let urlSession = MockURLSession()
                    urlSession.stubbedURLResponse = stubbedURLResponse
                    urlSession.stubbedData = try? jsonEncoder.encode(stubbedData)
                    
                    let service = NetworkingService()
                    service.session = urlSession
                    
                    var actualResult: NetworkingServiceError?
                    service.credit { result in
                        switch result {
                        case .success: XCTFail("Credit request should fail")
                        case let .failure(error): actualResult = error
                        }
                    }
                    
                    expect(actualResult).toEventually(equal(expectResult))
                }
                
                it("receives no network error") {
                    let expectResult: NetworkingServiceError = .noNetwork
                    
                    let stubbedError = NSError(domain: "networking_service_spec", code: 1040, userInfo: nil)
                    let urlSession = MockURLSession()
                    urlSession.stubbedError = stubbedError
                    
                    let service = NetworkingService()
                    service.session = urlSession
                    
                    var actualResult: NetworkingServiceError?
                    service.credit { result in
                        switch result {
                        case .success: XCTFail("Credit request should fail")
                        case let .failure(error): actualResult = error
                        }
                    }
                    
                    expect(actualResult).toEventually(equal(expectResult))
                }
            }
        }
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol { func resume() {} }
class MockURLSession: URLSessionProtocol {
    var stubbedDataTaskResult = MockURLSessionDataTask()
    var stubbedURLResponse: URLResponse!
    var stubbedData: Data!
    var stubbedError: Error?
    
    func dataTask(with urlRequest: URLRequest,
                  result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTaskProtocol {
        if let error = stubbedError {
            result(.failure(error))
            return stubbedDataTaskResult
        }
        
        result(.success((stubbedURLResponse, stubbedData)))
        
        return stubbedDataTaskResult
    }
}
