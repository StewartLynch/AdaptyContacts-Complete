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

struct ContactsListView: View {
    @EnvironmentObject var store: Store
    @State private var formType: FormType?
    @State private var showAbout = false
    var body: some View {
        NavigationView {
            List {
                ForEach(store.contacts) { contact in
                    HStack(alignment: .center) {
                        Image(systemName: "person.fill")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                        VStack(alignment: .leading) {
                            Text("\(contact.firstName) \(contact.lastName)")
                                .font(.title)
                            Text("\(contact.email)")
                        }
                        Spacer()
                        Button {
                            formType = .update(contact)
                        } label: {
                            Text("Edit")
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .onDelete(perform: store.delete)
            }
            .navigationTitle("Adapty Contacts")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showAbout.toggle()
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canCreate {
                        formType = .new
                        } else {
                            showAbout.toggle()
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(isPresented: $showAbout) {
                AboutView()
            }
            .sheet(item: $formType) { $0 }
        }
        .navigationViewStyle(.stack)
        .task {
            if let subscriptionType = await PurchaseManager.shared.hasPurchase() {
                print("premium purchased")
                store.level = .premium
                store.subscription = subscriptionType
            } else {
                print("still on trial")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsListView()
            .environmentObject(Store(preview: true))
    }
}
