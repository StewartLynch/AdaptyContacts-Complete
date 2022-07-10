//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-06
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import SwiftUI
import Adapty

@main
struct AppEntry: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
            ContactsListView()
                .environmentObject(store)
                .onAppear {
                    PurchaseManager.shared.configure()
                }
        }
    }
}
