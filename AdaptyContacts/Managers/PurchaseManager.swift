//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-07
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Adapty
import Foundation

class PurchaseManager {
    static let shared = PurchaseManager()
    
    private init() {}
    
    func configure() {
        Adapty.activate("YOUR_SDK_KEY_HERE")
    }
    
    func hasPurchase() async -> Subscription? {
        do {
            let purchaseInfo = try await Adapty.getPurchaserInfo(forceUpdate: true)
            if purchaseInfo?.accessLevels[PurchaseInfo.accessLevel]?.isActive == true {
                if let subscriptions = purchaseInfo?.subscriptions {
                    if subscriptions[PurchaseInfo.monthly]?.isActive == true {
                        return .monthly
                    }
                    if subscriptions[PurchaseInfo.annual]?.isActive == true {
                        return .annual
                    }
                }
                return nil
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getPaywalls() async -> [PaywallModel] {
        do {
            guard let paywalls = try await Adapty.getPaywalls().paywalls else {
                print("No Paywalls")
                return []
            }
            return paywalls
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func makePurchase(product: ProductModel) async -> Bool {
        do {
            let purchaseResult = try await Adapty.makePurchase(product: product)
            if purchaseResult.purchaserInfo?.accessLevels[PurchaseInfo.accessLevel]?.isActive == true {
                print("purchase made")
                return true
            } else {
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func restorePurchases() async -> Bool {
        do {
            let restoreResult = try await Adapty.restorePurchases()
            if restoreResult.purchaserInfo?.accessLevels[PurchaseInfo.accessLevel]?.isActive == true {
                print("restore complete")
                return true
            } else {
                print("No restore possible")
                return false
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
}
