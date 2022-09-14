//
//  NetworkService.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - NetworkError enum

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

// MARK: - NetworkCancellable protocol

protocol NetworkCancellable {
    func cancel()
}

// MARK: - URLSessionTask's NetworkCancellable implementation

extension URLSessionTask: NetworkCancellable {}

// MARK: - NetworkService protocol

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}

// MARK: - NetworkSessionManager protocol

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable
}

// MARK: - NetworkErrorLogger protocol

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - DefaultNetworkService class

final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(config: NetworkConfigurable,
         sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
         logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    // MARK: Private
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            if let requestError = requestError {
                var error: NetworkError
                
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                completion(.success(data))
            }
        }
        
        logger.log(request: request)
        
        return sessionDataTask
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

// MARK: - DefaultNetworkService's NetworkService implementation

extension DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}

// MARK: - DefaultNetworkSessionManager class

final class DefaultNetworkSessionManager: NetworkSessionManager {
    
    init() {}
    
    func request(_ request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - DefaultNetworkErrorLogger class

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() {}
    
    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
//        guard let data = data else { return }
        
//        if let dataDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//            printIfDebug("responseData: \(String(describing: dataDict))")
//        }
    }
    
    func log(error: Error) {
        printIfDebug("\(error)")
    }
}

// MARK: -

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
