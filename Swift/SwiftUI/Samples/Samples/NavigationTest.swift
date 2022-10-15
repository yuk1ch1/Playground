//
//  NavigationTest.swift
//  Samples
//
//  Created by s_yamada on 2022/10/15.
//
import SwiftUI

struct NavigationTest: View {
    @State var path: [String] = []
    
    var data: [String] = (0...100).map { _ in UUID().uuidString }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(data, id: \.self) { d in
                    Button(
                        action: { path.append(contentsOf: ["1", "2"])},
                    label: {
                        HStack {
                            Image(systemName: "chevron.right")
                            Text(d)
                        }
                    }
                    )
                    .foregroundColor(.primary)
                    
                    NavigationLink(value: "3") {
                        Text(d)
                    }
                }
            }
            .navigationDestination(for: String.self) { path in
                NavigationLink(value: "test push", label: { Text(path) })
            }
            .scrollIndicators(.hidden)
        }
    }
}
    

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationTest()
    }
}
