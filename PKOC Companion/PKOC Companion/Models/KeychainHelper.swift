//
//  KeychainHelper.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/24/23.
//

import Foundation
import Security

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    func saveToKeychain<T>(_ item: T, service: String, account: String) -> Bool where T : Codable {
        do {
            // Envode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            return save(data, service: service, account: account)
        } catch {
            assertionFailure("Failed to encode item to save to keychain: \(error)")
            print(error.localizedDescription)
            return false
        }
    }
    
    /*
     Helper function to save provided data into device's keychain
     
     Returns: true or false depending on whether the transaction was successful or not
     */
    private func save(_ data: Data, service: String, account: String) -> Bool {
        // Creating query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        // Adding data in query to device's keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        print("save status: \(status)")
        if status != errSecSuccess {
            if status == errSecDuplicateItem {
                print("Duplicate item")
                // Item exists in keychain, need to update it
                let updateQuery = [
                    kSecClass: kSecClassIdentity,
                    kSecAttrService: service,
                    kSecAttrAccount: account
                ] as CFDictionary
                
                let attributesToUpdate = [kSecValueData: data] as CFDictionary
                // Updating existing item
                let status1 = SecItemUpdate(updateQuery, attributesToUpdate)
                print("Update item status: \(status1)")
                return true
            }
            print("ERROR: keychain save error: \(status)")
            return false
        }
        return true
    }
    
    func readFromKeychain<T>(service: String, account: String, type: T.Type) -> T? where T : Codable {
        // Read item data from keychain
        guard let data = read(service: service, account: account) else {
            print("Error while reading data from keychain")
            return nil
        }
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            assertionFailure("Failed to decode item from keychain: \(error)")
            return nil
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        print("DEBUG: Printing data read from keychain: \(String(describing: result))")
        return (result as? Data)
    }
    
    func deleteFromKeychain(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassIdentity
        ] as CFDictionary
        
        // Deleting item from keychain
        SecItemDelete(query)
        
        print("DEBUG: I think item successfully deleted?")
    }
}

extension KeychainHelper {
    static var KeychainAccount = "PKOC_Companion_APP_Last_Lock1"
    static var KeychainService = "auth-token-credentials"
    static var SecureKeyService = "secure-key-credentials"
}
