//
//  ContentView.swift
//  SwiftConcurrencyByPersonalFactory
//
//  Created by s_yamada on 2022/10/15.
//

import SwiftUI
import UIKit

//struct ContentView: View {
//    var body: some View {
////        let _ = Task {
////            await printUserDetails()
////        }
//        let imageDownloader = ImageDownloader2()
//        let _ = readText()
//        let _ = Task.detached {
//            let image = await imageDownloader.image(from: "monster") // A
//            print(image)
//        }
//
//        let _ = Task.detached {
//            let image = await imageDownloader.image(from: "monster") // B
//            print(image)
//        }
//        Text("Hello, world!")
//            .padding()
//    }
//}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("APIを使う") {
                    UserAPIsView()
                }
//
//                NavigationLink("自分で作る") {
//                    CustomeAsyncSequence()
//                }
//
//                NavigationLink("AsyncSteam") {
//                    AsyncStreamView()
//                }

            }
            .listStyle(.insetGrouped)
            .navigationTitle("AsyncSequence")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UserData {
    let name: String
    let friends: [String]
    let highScores: [Int]
}

func getUser() async -> String {
    "Taylor Swift"
}

func getHighScores() async -> [Int] {
    [42, 23, 16, 15, 8, 4]
}

func getFriends() async -> [String] {
    ["Eric", "Maeve", "Otis"]
}

func printUserDetails() async {
    async let username = getUser()
    async let scores = getHighScores()
    async let friends = getFriends()
    
    let user = await UserData(name: username, friends: friends, highScores: scores)
    print("Hello, my name is \(user.name), and I have \(user.friends.count) friends!")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
