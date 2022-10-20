//
//
// Race Condition(競合状態)
//
//
//

import Foundation
import UIKit

actor RaceConditionProblem {
    var localLogs: [Int] = []
    private(set) var highScore: Int = 0
    
    func update(with score: Int) async {
        localLogs.append(score) // 1
        highScore = await requestHighScore(with: score) // 2
    }
    // サーバーに点数を送るとサーバーが集計した自分の最高得点が得られると想定するメ ソッド
    // 実際は2秒まって引数のscoreを返すだけ
    func requestHighScore(with score: Int) async -> Int {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2秒待つ
        return score
    }
}
// 実行
//
//let score = Score() Task.detached {
//await score.update(with: 100) // 3 print(await score.localLogs) // 3' print(await score.highScore) // 3''
//}
//Task.detached {
//await score.update(with: 110) // 4 print(await score.localLogs) // 4' print(await score.highScore) // 4''
//}






/// RaceConditionProblem2
///
/// Actorを使ってもDataRaceを防げるだけでRace Condition(競合状態)は発生してしまう
/// 同じURLの場合、明示的にクリアするまではキャッシュで持つ画像を返すようにしたいけど異なる画像が返されてしまうことが発生している
/// これは非同期処理の順序によって出力結果が異なってしまっているため、ImageDownloaderは競合状態の不具合を抱えている。
actor ImageDownloaderProblem {
    private var cached: [String: UIImage] = [:]
    func image(from url: String) async -> UIImage { // キャシュがあればそれを使う
        if cached.keys.contains(url) { // 1
            return cached[url]!
        }
        // ダウンロード
        let image = await downloadImage(from: url) // 2 // キャッシュに保存
        cached[url] = image // 3
        return cached[url]!
    }
    
    // サーバーに画像をリクエストすることを想定するメソッド
    // 2秒後に画像をランダムで返す
    func downloadImage(from url: String) async -> UIImage {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)  // 2秒待つ
        switch url {
        case "monster":
            // サーバー側でリソースが変わったことを表すためランダムで画像名をセット
            let imageName = Bool.random() ? "cow" : "fox"
            return UIImage(named: imageName)!
            
        default:
            return UIImage()
        }
    }
}

// 実行
//
//let imageDownloader = ImageDownloader()
//Task.detached {
//    let image = await imageDownloader.image(from: "monster") // A
//    print(image)
//}
//
//Task.detached {
//    let image = await imageDownloader.image(from: "monster") // B
//    print(image)
//}


/// 対応1
///
/// Actorはawaitの前後で状態が変わるのでawaitの後でキャッシュを調べ同じURLがあれば更新しないように変更
actor ImageDownloader {
    private var cached: [String: UIImage] = [:]
    // 改良対象
    func image(from url: String) async -> UIImage {
        if cached.keys.contains(url) {
            return cached[url]!
        }
        let image = await downloadImage(from: url) // awaitの後にキャッシュをチェック
        if !cached.keys.contains(url) { // 追加したコード
            cached[url] = image
        }
        return cached[url]!
    }
    
    // サーバーに画像をリクエストすることを想定するメソッド
    // 2秒後に画像をランダムで返す
    func downloadImage(from url: String) async -> UIImage {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2秒待つ
        switch url {
        case "monster":
            // サーバ側でリソースが変わったことを表すためランダムで画像名をセットする
            let imageName = Bool.random() ? "cow" : "fox"
            return UIImage(named: imageName)!
            
        default:
            return UIImage()
        }
    }
}

/// 対応２
///
/// Taskで競合状態を防ぐ
actor ImageDownloader2 {
    private enum CacheEntry {
        case inProgress(Task<UIImage, Never>)
        case ready(UIImage)
    }
    
    // キャッシュにTaskを保存する
    private var cache: [String: CacheEntry] = [:]
    func image(from url: String) async -> UIImage? { // キャッシュをチェック
        print(cache)
        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                // 処理中ならtask.valueで画像を取得
                // awaitがあるのでプログラムは中断する
                return await task.value // 2
            }
        }
        let task = Task {
            await downloadImage(from: url)
        }
        // taskをキャッシュに保存する
        // awaitがないため、プログラムは中断しない
        cache[url] = .inProgress(task)
        // task.valueでimageを取得
        let image = await task.value // 1
        cache[url] = .ready(image)
        return image
    }
    
    // サーバーに画像をリクエストすることを想定するメソッド
    // 2秒後に画像をランダムで返す
    func downloadImage(from url: String) async -> UIImage {
        try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC) // 2秒待つ
        switch url {
        case "monster":
            // サーバ側でリソースが変わったことを表すためランダムで画像名をセットする
            let imageName = Bool.random() ? "cow" : "fox"
            return UIImage(named: imageName)!
            
        default:
            return UIImage()
        }
    }
}
