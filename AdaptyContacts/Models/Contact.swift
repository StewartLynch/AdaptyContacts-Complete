//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-06
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

struct Contact: Identifiable, Codable {
    var id = UUID().uuidString
    var firstName: String
    var lastName: String
    var email: String

    static var fileName = "Contacts.json"
    
    static var sampleContacts: [Contact] {
        [
        Contact(firstName: "Stewart", lastName: "Lynch", email: "slynch@createchsol.com"),
        Contact(firstName: "Johnny", lastName: "Appleseed", email: "johhny@apple.com")
        ]
    }
}
