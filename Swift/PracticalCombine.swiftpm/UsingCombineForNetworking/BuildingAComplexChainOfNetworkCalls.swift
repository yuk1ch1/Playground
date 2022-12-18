//
//  File.swift
//  
//
//  Created by s_yamada on 2022/12/17.
//

import Foundation
import Combine

enum SectionType: String, Decodable {
    case featured, favorites, curated
}

struct Event: Decodable, Hashable {
    // event properties
}

struct HomePageSection {
    let events: [Event]
    let sectionType: SectionType
    
    static func featured(events: [Event]) -> HomePageSection {
        return HomePageSection(events: events, sectionType: .featured)
    }
    
    static func favorites(events: [Event]) -> HomePageSection {
        return HomePageSection(events: events, sectionType: .favorites)
    }
    
    static func curated(events: [Event]) -> HomePageSection {
        return HomePageSection(events: events, sectionType: .curated)
    }
}

let featuredContentURL = URL(string: "")!
let curatedContentURL  = URL(string: "")!


var featuredPublisher = URLSession.shared.dataTaskPublisher(for: featuredContentURL)
    .map({ $0.data })
    .decode(type: [Event].self, decoder: JSONDecoder())
    .replaceError(with: [Event]())
    .map({ HomePageSection.featured(events: $0) })
    .eraseToAnyPublisher()

var curatedPublisher = URLSession.shared.dataTaskPublisher(for: curatedContentURL)
    .map({ $0.data })
    .decode(type: [Event].self, decoder: JSONDecoder())
    .replaceError(with: [Event]())
    .map({ HomePageSection.curated(events: $0) })
    .eraseToAnyPublisher()

class LocalFavorites {
    static func fetchAll() -> AnyPublisher<[Event], Never> {
        // retrieve events from a local source
        return Just([Event]()).eraseToAnyPublisher()
    }
}

var localFavoritesPublisher = LocalFavorites.fetchAll()

var remoteFavoritesPublisher = URLSession.shared.dataTaskPublisher(for: curatedContentURL)
    .map({ $0.data })
    .decode(type: [Event].self, decoder: JSONDecoder())
    .replaceError(with: [Event]())
    .eraseToAnyPublisher()

var favoritesPublisher = Publishers.Zip(localFavoritesPublisher, remoteFavoritesPublisher)
    .map({ (local, remote) -> HomePageSection in
        let uniqueFavorites = Set(local + remote) // zipの結果はtuple
        return HomePageSection.favorites(events: Array(uniqueFavorites))
    })
    .eraseToAnyPublisher()

var homePagePublisher = Publishers.Merge3(featuredPublisher, curatedPublisher, favoritesPublisher)

func subScribeHomePagePublisher() {
    homePagePublisher
        .sink(receiveValue: { section in
            switch section.sectionType {
            case .featured: break
                // render featured section
            case .curated: break
                // render curated section
            case .favorites: break
                // render favorites section
            }
        }).store(in: &cancellables)
}
