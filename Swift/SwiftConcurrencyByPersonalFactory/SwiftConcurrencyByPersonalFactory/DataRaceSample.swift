//
//
// Data Race(データ競合)
//
//


import Foundation

// データ競合を起こす
class DataRaceProblem {
    var logs: [Int] = []
    private(set) var highScore: Int = 0
    func update(with score: Int) { logs.append(score)
        if score > highScore { // 1
            highScore = score // 2 }
        }
    }
}

// actorにするだけでデータ競合を防ぐことができる
actor Score {
    var logs: [Int] = []
    private(set) var highScore: Int = 0
    
    func update(with score: Int) { logs.append(score)
        if score > highScore {
            highScore = score }
    }
}

// 一応serial(直列)DispatchQueueを使うことでもデータ競合を防ぐことはできるけど面倒
class Score2 {
    var logs: [Int] = []
    private let serialQueue = DispatchQueue(label: "serial-dispatch-queue")
    private(set) var highScore: Int = 0
    
    func upcate(with score: Int, completion: @escaping ((Int) -> ())) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            self.logs.append(score)
            if score > self.highScore {
                self.highScore = score
            }
            completion(self.highScore)
        }
    }
}

// Hashableに準拠するために同期関数hash(into:)を実装しないといけない場合nonisolatedを付けることで実現できる
actor Score3: Hashable {
    static func == (lhs: Score3, rhs: Score3) -> Bool {
        lhs.id == rhs.id
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = UUID()
    private(set) var number = 0
    
    func increace() { // データ競合から守られている値を変更する関数、プロパティにisolatedをコンパイルエラーとなる
        number += 1
    }
}

/*
 - 何かしらのプロトコルに準拠して同期関数を実装さざるを得ない場合nonisolatedを付けることで実現できるがデータ競合しないように守られているデータを更新するメソッドはnonisolatedをつけてしまうとコンパイラがエラーで弾いてくれる
 */
