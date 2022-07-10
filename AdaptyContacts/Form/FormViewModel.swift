//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-06
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

class FormViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    
    var id: String?
    
    var updating: Bool { id != nil }
    
    init() {}
    
    init(_ contact: Contact) {
        firstName = contact.firstName
        lastName = contact.lastName
        email = contact.email
        id = contact.id
    }
    
    var incomplete: Bool {
        firstName.isEmpty || lastName.isEmpty || email.isEmpty
    }
}
