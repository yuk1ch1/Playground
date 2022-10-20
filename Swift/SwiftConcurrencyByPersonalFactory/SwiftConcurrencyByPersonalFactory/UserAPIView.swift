//
//  UserAPIViews.swift
//  SwiftConcurrencyByPersonalFactory
//
//  Created by s_yamada on 2022/10/16.
//

import SwiftUI

struct UserAPIsView: View {
    
    @StateObject
    private var viewModel: UserAPIsViewModel

    init() {
        self._viewModel = StateObject(wrappedValue: UserAPIsViewModel())
    }

    var body: some View {
        VStack {
            TextEditor(text: $viewModel.text)
                .frame(height: 300)
            Button {
                viewModel.readText()
            } label: {
                Text("ファイル読み込み")
            }

        }
        .navigationTitle("APIを使う")
        .onAppear {
            viewModel.checkAppStatus()

        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
}

@MainActor
final class UserAPIsViewModel: ObservableObject {

    @Published
    var text: String = ""

    var enterForegroundTask: Task<Void, Never>?
    var enterBackgroundTask: Task<Void, Never>?

    func checkAppStatus() {
        lagacyObserve()
        let notificationCenter = NotificationCenter.default
        enterForegroundTask = Task {
            let willEnterForeground = notificationCenter.notifications(named: UIApplication.willEnterForegroundNotification)

            for await notification in willEnterForeground {
                print(notification)
            }
        }

        enterBackgroundTask = Task {
            let didEnterBackground = notificationCenter.notifications(named: UIApplication.didEnterBackgroundNotification)

            for await notification in didEnterBackground {
                print(notification)
            }
        }
    }

    func lagacyObserve() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                       object: nil, queue: nil) { notification in
            print("\(notification)")
        }
    }

    func readText() {
        Task {
            text = ""
            guard let url = Bundle.main.url(forResource: "text", withExtension: "txt") else {
                return
            }
            do {
                for try await line in url.lines {
                    print(line)
                    if line == "apple" {
                        continue
                    }

                    if line == "five" {
                        break
                    }
                    text += "\(line)\n"
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func cleanup() {
        enterForegroundTask?.cancel()
        enterBackgroundTask?.cancel()
    }
}

struct Counter {
    struct AsyncCounter: AsyncSequence {
        typealias Element = Int
        let amount: Int
        
        struct AsyncIterator: AsyncIteratorProtocol {
            var amount: Int
            mutating func next() async -> Element? {
                guard amount >= 0 else {
                    // 0未満だったらnilを返す(ループを終了する)
                    return nil
                }
                
                let result = amount
                amount -= 1
                return result
            }
        }
        
        func makeAsyncIterator() -> AsyncIterator {
            return AsyncIterator(amount: amount)
        }
    }
    
    func countdown(amount: Int) -> AsyncCounter {
        return AsyncCounter(amount: amount)
    }
}
