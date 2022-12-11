//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/09.
//

/*
 
 Assigning the output of a publisher to an @Published property with assign(to:)
 
 */


import Foundation
import Combine
import SwiftUI


fileprivate struct CardModel: Hashable, Decodable {
  let title: String
  let subTitle: String
  let imageName: String
}

fileprivate class DataProvider {
    @Published
    var fetchedModels = [CardModel]()
    
    var currentPage = 0
    
    func fetchNextPage() {
        let url = URL(string: "https://myserver.com/page/\(currentPage)")!
        currentPage += 1
        
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ [weak self] value -> [CardModel] in
                let jsonDecoder = JSONDecoder()
                let models = try jsonDecoder.decode([CardModel].self, from: value.data)
                let currentModels = self?.fetchedModels ?? []
                
                return currentModels + models
            })
            .replaceError(with: fetchedModels)
            .assign(to: &$fetchedModels)
    }
}
