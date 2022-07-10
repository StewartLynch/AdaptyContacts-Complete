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

struct Config {
    var header = "Subscriptions"
    var subHeader = "Remove all restrictions and create as many contacts as you like."
    var image = "premiumLogo"
    var fgColor = "#FFFFFFFF"
    var bgColor = "#661FFFFF"
}

struct AboutView: View {
    @EnvironmentObject var store: Store
    @Environment(\.dismiss) var dismiss
    @State private var paywalls: [PaywallModel] = []
    @State private var products: [ProductModel] = []
    @State private var config = Config()
    var body: some View {
        NavigationView {
            VStack {
                if store.subscription == .annual {
                    welcomeView
                } else {
                    VStack {
                        Text(config.header)
                            .font(.title)
                        if store.level != .premium {
                            Text("You are currently limited to \(Level.trial.max!) contacts.")
                                .fontWeight(.light)
                        }
                        Text(config.subHeader)
                            .font(.headline)
                        ForEach(products, id: \.skProduct) { product in
                            Button {
                                Task {
                                    if await PurchaseManager.shared.makePurchase(product: product) {
                                        store.subscription = await PurchaseManager.shared.hasPurchase()
                                        store.level = .premium
                                        dismiss()
                                    }
                                }
                            } label: {
                                VStack {
                                    Text(product.localizedTitle)
                                    Text(product.localizedPrice ?? "")
                                }
                                .padding(5)
                            }
                            .frame(width: 175)
                            .foregroundColor(Color(uiColor: UIColor(hex: config.fgColor)!))
                            .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(uiColor: UIColor(hex: config.bgColor)!)))
                            .padding(5)
                        }
                    }
                    Button {
                        Task {
                            if await PurchaseManager.shared.restorePurchases() {
                                store.subscription = await PurchaseManager.shared.hasPurchase()
                                store.level = .premium
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                    .buttonStyle(.bordered)
                    Image(config.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                }
                Spacer()
            }
            .padding()
            .navigationTitle(store.level == .premium ? "About Adapty Contacts" : "Premium Subscription")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
        .task {
            if store.subscription == .monthly {
                store.paywallId = PurchaseInfo.paywallId2
            }
            paywalls = await PurchaseManager.shared.getPaywalls()
            guard let paywall = paywalls.first(where: {$0.developerId == store.paywallId}) else {
                print("Could not retrieve paywall")
                return
            }
            try? await Adapty.logShowPaywall(paywall)
            if let aConfig = paywall.customPayload {
                if let header = aConfig["header"] as? String {
                    config.header = header
                }
                if let subHeader = aConfig["subHeader"] as? String {
                    config.subHeader = subHeader
                }
                if let image = aConfig["image"] as? String {
                    config.image = image
                }
                if let fgColor = aConfig["fgColor"] as? String {
                    config.fgColor = fgColor
                }
                if let bgColor = aConfig["bgColor"] as? String {
                    config.bgColor = bgColor
                }
            }
            products = paywall.products
        }
        .navigationViewStyle(.stack)
    }
    
    var welcomeView: some View {
        VStack {
            Text("Welcome")
                .font(.largeTitle)
            Text("You can find out more information about Adapty at [https://adapty.io](https://adapty.io)")
                .foregroundColor(.secondary)
            
            Image("AdaptyLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 150)
                .foregroundColor(.accentColor)
        }
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutView()
                .environmentObject(Store())
        }
    }
}
