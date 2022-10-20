//
//  MainActorSample.swift
//  SwiftConcurrencyByPersonalFactory
//
//  Created by s_yamada on 2022/10/16.
//

import Foundation
import Combine

// 型全体にMainActorを適応
// MainActorとnonisolatedを組み合わせることで、メインスレッドをブロックせずにUIデータを更新することができる
@MainActor
final class ViewModel: ObservableObject {
    // @PublishedはObservableObjectプロトコルに準拠したクラス内のプロパティを監視し、変化があった際にViewに対して通知を行う役目がある。@Stateに近い機能
    //
    // 暗黙的にMainActorが適応されている
    @Published
    private(set) var text: String = ""
    
    // サーバーからユーザーを取得することを想定したメソッド
    // サーバー通信はメインスレッドで実行すべきではないのでnonisolatedをつける
    nonisolated func fetchUser() async -> String {
        return await waitOneSecond(with: "arex")
        
        // ちなみにnonisolatedをつけてるのにこの中でデータを更新しようとすると以下のようなエラーが発生する。
        // nonisolatedのメソッド内でプロパティは更新できない
        // Property 'text' isolated to global actor
        // 'MainActor' can not be mutated from a non-isolated context
        // text = await waitOneSecond(with: "arex")
    }
    func didTapButton() {
        Task {
            text = ""
            text = await fetchUser()
        }
    }
    
    private func waitOneSecond(with string: String) async -> String {
        try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC) // 1秒待つ
        return string
    }
}
