//
//  CollectionView.swift
//  PracticalCombine
//
//  Created by s_yamada on 2022/12/06.
//

import Foundation
import Combine
import SwiftUI


fileprivate struct CardModel: Hashable, Decodable {
  let title: String
  let subTitle: String
  let imageName: String
}

fileprivate class DataProvider {
    let dataSubject = CurrentValueSubject<[CardModel], Never>([])
    
    var currentPage = 0
    var cancellables = Set<AnyCancellable>()

    func fetch() {
        let cards = (0..<20).map { i in
            CardModel(title: "Title \(i)", subTitle: "Subtitle \(i)", imageName: "image_\(i)")
        }

        dataSubject.value = cards
    }
    
    func fetchImage(named imageName: String) -> AnyPublisher<UIImage?, URLError> {
      let url = URL(string: "https://imageserver.com/\(imageName)")!

      return URLSession.shared.dataTaskPublisher(for: url)
        .map { result in
          return UIImage(data: result.data)
        }
        .eraseToAnyPublisher()
    }
}

fileprivate class SampleCollectionViewController: UICollectionViewController {
    
    private let dataProvider = DataProvider()
    
    private lazy var cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, CardModel> { [weak self] cell, _, mode in
        guard let self else { return }
        cell.contentConfiguration = {
            var contentConfiguration = cell.defaultContentConfiguration()
            let text: String = "ダミーテキスト"
            contentConfiguration.text = text
            contentConfiguration.textProperties.color = .red
            contentConfiguration.textProperties.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 18))

            return contentConfiguration
        }()
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, CardModel> = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.identifier, for: indexPath) as! CardCell
        
        cell.cancellable = self?.dataProvider.fetchImage(named: item.imageName)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                // handle errors if needed
                
            },receiveValue: { image in
                cell.imageView.image = image
            })
        
        return cell
    }
    
    private lazy var dataSource2: UICollectionViewDiffableDataSource<Int, CardModel> = .init(collectionView: collectionView) { [cellRegistration] collectionView, indexPath, item in
        collectionView.dequeueConfiguredReusableCell(
            using: cellRegistration,
            for: indexPath,
            item: item
        )
    }
    
    override func viewDidLoad() {
//      dataProvider.fetch()

      dataProvider.dataSubject
        .sink(receiveValue: self.applySnapshot)
        .store(in: &cancellables)
    }

    func applySnapshot(_ models: [CardModel]) {
      var snapshot = NSDiffableDataSourceSnapshot<Int, CardModel>()
      snapshot.appendSections([0])

      snapshot.appendItems(models)

      dataSource.apply(snapshot)
    }
}

fileprivate class CardCell: UICollectionViewCell {
    static var identifier:String {
        CardCell.self.description()
    }
    
    var cancellable: Cancellable?
    let imageView = UIImageView()
}
