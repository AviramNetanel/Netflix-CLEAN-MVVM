//
//  DataTransferService.swift
//  netflix
//
//  Created by Zach Bazov on 01/09/2022.
//

import Foundation

// MARK: - DataTransferError enum

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworlFailure(Error)
}

// MARK: - DataTransferService protocol

protocol DataTransferService {
    
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where E.Response == T
    
    @discardableResult
    func request<E: ResponseRequestable>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E.Response == Void
}

// MARK: - DataTransferErrorResolver protocol

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

// MARK: - ResponseDecoder protocol

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws ->T
}

// MARK: - DataTransferErrorLogger protocol

protocol DataTransferErrorLogger {
    func log(error: Error)
}

// MARK: - DefaultDataTransferService class

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    init(with networkService: NetworkService,
         errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
         errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

// MARK: DefaultDataTransferService's DataTransferService implementation

extension DefaultDataTransferService: DataTransferService {
    
    func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler<T>) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestable {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(data: data, decoder: endpoint.responseDecoder)
                DispatchQueue.main.async {
                    return completion(result)
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    return completion(.failure(error))
                }
            }
        }
    }
    
    func request<E>(with endpoint: E, completion: @escaping CompletionHandler<Void>) -> NetworkCancellable? where E : ResponseRequestable, E.Response == Void {
        return self.networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    return completion(.success(()))
                }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                DispatchQueue.main.async {
                    return completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: Private
    
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) -> Result<T, DataTransferError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworlFailure(resolvedError)
    }
}

// MARK: - DefaultDataTransferErrorLogger class

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() {}
    
    func log(error: Error) {
        printIfDebug("------------")
        printIfDebug("\(error)")
    }
}

// MARK: - DefaultDataTransferErrorResolver class

final class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() {}
    
    func resolve(error: NetworkError) -> Error {
        return error
    }
}

// MARK: - JSONResponseDecoder class

final class JSONResponseDecoder: ResponseDecoder {
    private let decoder = JSONDecoder()
    
    init() {}
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}

// MARK: - RawDataResponseDecoder class

final class RawDataResponseDecoder: ResponseDecoder {
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    init() {}
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type.")
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}
