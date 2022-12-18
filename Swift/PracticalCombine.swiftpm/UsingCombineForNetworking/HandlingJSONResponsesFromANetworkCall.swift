//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/16.
//

import Foundation
import Combine

private struct APIError: Decodable, Error {
    // fields that model your error
    let statusCode: ErrorType
    let message: String
    
    enum ErrorType: Int, Decodable {
        case Unauthorized = 401
    }
}

private struct MyModel: Decodable {}

private func fetchURLWithErrorHandling<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
            let decoder = JSONDecoder()
            guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                let apiError = try decoder.decode(APIError.self, from: result.data)
                throw apiError
            }
            
            return try decoder.decode(T.self, from: result.data)
        })
        .eraseToAnyPublisher()
}

private func fetchURLWithRedundantErrorHandling<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .mapError({ $0 as Error })
    .flatMap({ result -> AnyPublisher<T, Error> in
      guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
        return Just(result.data)
          .decode(type: APIError.self, decoder: JSONDecoder())
          .tryMap({ errorModel in
            throw errorModel
          })
          .eraseToAnyPublisher()
      }

      return Just(result.data).decode(type: T.self, decoder: JSONDecoder()).eraseToAnyPublisher()
    }).eraseToAnyPublisher()
}

private func executeFetchURL() {
    let myURL = URL(string: "")!
    
    fetchURLWithErrorHandling(myURL)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion,
               let apiError = error as? APIError {
                print(apiError)
            }
        }, receiveValue: { (model: MyModel) in
            print(model)
        }).store(in: &cancellables)
}

private func refreshToken() -> AnyPublisher<Bool, Never> {
  // normally you'd have your refresh logic here
  return Just(false)
        .eraseToAnyPublisher()
}

private func fetchURLFinal<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
    URLSession.shared.dataTaskPublisher(for: url)
        .tryMap({ result in
            let decoder = JSONDecoder()
            guard let urlResponse = result.response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode) else {
                let apiError = try decoder.decode(APIError.self, from: result.data)
                throw apiError
            }
            
            return try decoder.decode(T.self, from: result.data)
        })
        .tryCatch({ error -> AnyPublisher<T, Error> in
            guard let apiError = error as? APIError, apiError.statusCode == .Unauthorized else {
                throw error
            }
            
            return refreshToken()
                .tryMap({ success -> AnyPublisher<T, Error> in
                    guard success else { throw error }
                    
                    return fetchURLFinal(url)
                })
                .switchToLatest()
                .eraseToAnyPublisher()
        })
        .eraseToAnyPublisher()
}
