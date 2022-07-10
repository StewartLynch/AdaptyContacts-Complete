//
// Created for AdaptyContacts
// by Stewart Lynch on 2022-07-06
// Using Swift 5.0
//
// Follow me on Twitter: @StewartLynch
// Subscribe on YouTube: https://youTube.com/StewartLynch
//

import Foundation

class Store: ObservableObject {
    @Published var contacts: [Contact] = []
    @Published var level: Level = .trial
    @Published var paywallId = PurchaseInfo.paywallId
    @Published var subscription: Subscription?
    var preview: Bool
    var canCreate: Bool {
        guard let max = level.max else {
            return true
        }
        return contacts.count < max
    }
    init(preview: Bool = false) {
        self.preview = preview
        if preview {
            self.contacts = Contact.sampleContacts
        } else {
            loadContacts()
        }
    }

    // MARK: - CRUD Functions
    // CREATE
    func create(_ newContact: Contact) {
        contacts.append(newContact)
        saveContacts()
    }
    
    // READ
    func loadContacts() {
        // decode from file stored in the application document directory
        guard let data = try? FileManager().readDocument(docName: Contact.fileName) else { return }
        guard let contacts = try? JSONDecoder().decode([Contact].self, from: data) else { return }
        self.contacts = contacts
    }
    
    // UPDATE
    func update(_ contact: Contact) {
        guard let index = contacts.firstIndex(where: { $0.id == contact.id}) else { return }
        contacts[index] = contact
        saveContacts()
    }

    // DELETE
    func delete(at indexSet: IndexSet) {
        contacts.remove(atOffsets: indexSet)
        saveContacts()
    }

    // SAVE
    func saveContacts() {
        if preview { return }
        // Encode and replace file stored in the application document directory
        guard let data = try? JSONEncoder().encode(contacts) else { return }
        let jsonString = String(decoding: data, as: UTF8.self)
        try? FileManager().saveDocument(contents: jsonString, docName: Contact.fileName)
    }
}
