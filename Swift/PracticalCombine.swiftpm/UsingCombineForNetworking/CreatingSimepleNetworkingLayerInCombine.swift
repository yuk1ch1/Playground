//
//  CreatingSimepleNetworkingLayerInCombine.swift
//  
//
//  Created by s_yamada on 2022/12/17.
//

import Foundation
import Combine

/*
 The sample code below shows us how you can use Combine to decode JSON from a data task
*/

private func executeFetchURL() {
    let url = URL(string: "")!
    
    fetchURLWithTryMap(url)
        .sink(receiveCompletion: { completion in
        print(completion)
      }, receiveValue: { (model: MyModel) in
        print(model)
      })
        .store(in: &cancellables)
    
    fetchURLWithDecodeOperator(url)
        .sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { (model: MyModel) in
            print(model)
        })
        .store(in: &cancellables)
}

private struct MyModel: Decodable {}

/*
 If the task fails, the tryMap operator is skipped and the subscriber of the AnyPublisher that is returned by fetchURL immediately receives the error.
 If the request succeds, the response data is extracted from the result and its decoded into the generic model that the caller of this function needs.
 Because I used a tryMap here, any errors that occur while decoding the data are automatically forwarded to the subscriber of the resulting publisher
 */
private func fetchURLWithTryMap<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .tryMap({ result in
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: result.data)
    })
    .eraseToAnyPublisher()
}

/*
 Combine provides a decode operator that works on publishers that have Data Type as their Output
 The method below is more simple, and this is quite straightforward.
 */
private func fetchURLWithDecodeOperator<T: Decodable>(_ url: URL) -> AnyPublisher<T, Error> {
  URLSession.shared.dataTaskPublisher(for: url)
    .map(\.data)
    .decode(type: T.self, decoder: JSONDecoder()) // decodes a given type using a specified decoder and published the result
    .eraseToAnyPublisher()
}
