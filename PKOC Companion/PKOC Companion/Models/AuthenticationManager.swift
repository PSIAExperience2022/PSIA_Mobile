//
//  AppManager.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import Foundation
import Combine
import LocalAuthentication
import CryptoKit

class AuthenticationManager: ObservableObject {
    static var isUserAuthenticated = PassthroughSubject<Bool, Never>()
    
    static private var publicKey: Curve25519.Signing.PublicKey? = nil
    static private var privateKey: Curve25519.Signing.PrivateKey? = nil
    
    static func exportPublicKey() -> Curve25519.Signing.PublicKey {
        return publicKey!
    }
    
    static func exportPrivateKey() -> Curve25519.Signing.PrivateKey {
        return privateKey!
    }
    
    static func faceIDAuthenticate(completionHandler: @escaping (Result<Bool, AuthenticationError>) -> Void) {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it is possible to use biometric authentication, using it
            let reason = "Need authorization to give access"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    // authenticated successfully
                    print("User authenticated successfully")
                    completionHandler(.success(true))
                    return

                } else {
                    // something fucky happened
                    print("ERROR: authenticationError: \(authenticationError)")
                    completionHandler(.failure(AuthenticationError.IncorrectCredentials))
                }
            }
        }
    }
    
    static func signNonceWithPrivateKey(nonce: Data, _ compHand: @escaping (Result<[UInt8], Error>) -> Void) {
        guard self.privateKey != nil else {
            print("ERROR: Private Key is nill")
            compHand(.failure(AuthenticationError.UnknownError))
            return
        }
        guard let signature = try! self.privateKey?.signature(for: nonce) else {
            print("ERROR: Error generating signature from nonce and private key")
            compHand(.failure(AuthenticationError.UnknownError))
            return
        }
        print("Signature for the nonce: \(signature)")
        
         compHand(.success([UInt8](signature)))
    }
    
    private static func removeASNHeaderFromSignature() {
        
    }
    
    /*
     Assigns the key values based on the values provided
     */
    static func loadKeys(privateKey: Curve25519.Signing.PrivateKey, publicKey: Curve25519.Signing.PublicKey) {
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    static func generateAndSendPublishKey(_ completionHandler: @escaping (Bool) -> Void) {
        // Create an asymmertic key pair with Elliptic Curve crypto
        // using EcdsaSignatureMessageX962Sha256
        // Creating a random private key to use
        let signingKey = Curve25519.Signing.PrivateKey()
        self.privateKey = signingKey
        
        // Get a data representation of the public key from this private key
        let signingPublicKey = signingKey.publicKey
        let signingPublicKeyData = signingPublicKey.rawRepresentation
        self.publicKey = signingPublicKey
        print("SigningPublicKey: \(signingPublicKey)")
        print("SigningPublicKeyData: \(signingPublicKeyData)")
        completionHandler(true)
    }
}

enum AuthenticationError: Error {
    case IncorrectCredentials
    case LogoutFailed
    case UnknownError
}

extension AuthenticationError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .IncorrectCredentials:
            return "Incorrect email or password "
        case .LogoutFailed:
            return "Something went wrong while Logging out"
        case .UnknownError:
            return "Unknown error!"
        }
    }
}
