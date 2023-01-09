//
//  File.swift
//  
//
//  Created by s_yamada on 2023/01/09.
//

import Foundation
import Combine
import UIKit

struct Token {
  let isValid: Bool
}

class Authenticator {
  private var currentToken = Token(isValid: false)

  func refreshToken<S: Subject>(using subject: S) where S.Output == Token {
    self.currentToken = Token(isValid: true)
    subject.send(currentToken)
  }

  func tokenSubject() -> CurrentValueSubject<Token, Never> {
    return CurrentValueSubject(currentToken)
  }
}

struct UserApi {
    let authenticator: Authenticator

    func getProfile() -> AnyPublisher<Data, URLError> {
        let tokenSubject = authenticator.tokenSubject()

        return tokenSubject
            .flatMap({ token -> AnyPublisher<Data, URLError> in
                let url: URL = URL(string: "https://www.donnywals.com")!

                return URLSession.shared.dataTaskPublisher(for: url)
                    .flatMap({ result -> AnyPublisher<Data, URLError> in
                        if let httpResponse = result.response as? HTTPURLResponse,
                           httpResponse.statusCode == 403 {

                            self.authenticator.refreshToken(using: tokenSubject)
                            return Empty().eraseToAnyPublisher()
                        }

                        return Just(result.data)
                            .setFailureType(to: URLError.self)
                            .eraseToAnyPublisher()
                    })
                    .eraseToAnyPublisher()
            })
            .handleEvents(receiveOutput: { _ in
                tokenSubject.send(completion: .finished)
            })
            .eraseToAnyPublisher()
    }
}
