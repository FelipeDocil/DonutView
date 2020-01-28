//
//  NetworkingService.swift
//  DonutView
//
//  Created by Felipe Docil on 28/01/2020.
//  Copyright © 2020 Felipe Docil. All rights reserved.
//

import Foundation

private enum Request {
    private var baseURL: String {
        return "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/"
    }
    
    case credit
    
    func request(with method: String, endpoint: String, parameters: [String: String], againstBaseURL: Bool) -> URLRequest {
        let urlString = againstBaseURL ? baseURL + endpoint : endpoint
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL, attempt to use this one: \(urlString + endpoint)")
        }
        
        var request = URLRequest(url: url)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters.map { arg -> URLQueryItem in
            let (key, value) = arg
            return URLQueryItem(name: key, value: value)
        }
        
        if let queryURL = components?.url {
            request = URLRequest(url: queryURL)
        }
        
        request.httpMethod = method.uppercased()
        request.timeoutInterval = 10
        
        return request
    }
    
    var request: URLRequest {
        switch self {
        case .credit:
            let endpoint = "prod/mockcredit/values"
            let parameters: [String: String] = [:]
            
            var urlRequest = request(with: "GET", endpoint: endpoint, parameters: parameters, againstBaseURL: true)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return urlRequest
        }
    }
}

enum NetworkingServiceError: Error {
    case invalidRequest
    case noNetwork
}

protocol NetworkingServiceInput {
    func credit(completionHandler: @escaping (Result<Credit, NetworkingServiceError>) -> Void)
}

class NetworkingService: NetworkingServiceInput {
    var session: URLSessionProtocol = URLSession.shared
    
    func credit(completionHandler: @escaping (Result<Credit, NetworkingServiceError>) -> Void) {
        let request = Request.credit.request
        
        let task = session.dataTask(with: request) { result in
            switch result {
            case let .success(response, data):
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    completionHandler(.failure(.invalidRequest))
                    return
                }
                
                let decoder = JSONDecoder()
                let metadata = try! decoder.decode(Metadata.self, from: data)
                let credit = metadata.creditReportInfo
                completionHandler(.success(credit))
            case .failure:
                completionHandler(.failure(.noNetwork))
            }
        }
        
        task.resume()
    }
}

internal struct Metadata: Codable {
    var creditReportInfo: Credit
}

protocol URLSessionDataTaskProtocol { func resume() }
protocol URLSessionProtocol {
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) ->
    URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }
extension URLSession: URLSessionProtocol {
    func dataTask(with urlRequest: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) ->
        URLSessionDataTaskProtocol {
            return dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    result(.failure(error))
                    return
                }
                guard let response = response, let data = data else {
                    let error = NSError(domain: "URLSession", code: 400, userInfo: nil)
                    result(.failure(error))
                    return
                }
                result(.success((response, data)))
                } as URLSessionDataTaskProtocol
    }
}
