//
//  ContentView.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/19/23.
//

import SwiftUI
import CryptoKit

struct ContentView: View {
    
    @State private var isUserAuthenticated: Bool = false
    
    func loadSecureKeysData() {
        KeyStore.load() { result in
            switch result {
            case .failure(let error):
                print("ERROR/WARNING: \(error)")
                AuthenticationManager.generateAndSendPublishKey() { _ in
                    print("DEBUG: New keys created!")
                    print("DEBUG: Saving these keys to storage")
                    storeSecureKeyData()
                }
            case .success(let keys):
                print("Keys fetched from storage public: \(keys.publicKey.base64EncodedString())")
                print("Keys fetched from storage private: \(keys.privateKey.base64EncodedString())")
                do {
                    try AuthenticationManager.loadKeys(privateKey: Curve25519.Signing.PrivateKey(rawRepresentation: keys.privateKey), publicKey: Curve25519.Signing.PublicKey(rawRepresentation: keys.publicKey))
                } catch {
                    print("Error: Error in converting keys from storage to app data")
                    fatalError()
                }
            }
        }
    }
    
    /*
     Stores the freshly created keys in device's secure persistent storage
     */
    func storeSecureKeyData() {
        KeyStore.save(keyData: KeyData(publicKey: AuthenticationManager.exportPublicKey().rawRepresentation, privateKey: AuthenticationManager.exportPrivateKey().rawRepresentation)) { result in
            switch result {
            case .success( _):
                print("Saving to persistent storage successful")
            case .failure(let error):
                print("ERROR saving to persistent storage: \(error)")
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            VStack {
                ScanningView().environmentObject(BluetoothController())
            }
            .padding()
        }
        .onAppear() {
            loadSecureKeysData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.dark)
    }
}


extension Color {
    static var primaryBackground = Color("primaryBackground")
    static var textboxBackground = Color("textboxBackground")
    static var textboxStroke = Color("textboxStroke")
    static var textPrimaryColor = Color("textPrimaryColor")
    static var textSecondaryColor = Color("textSecondaryColor")
    static var slideToUnlockBackground = Color("slideToUnlockBackground")
    static var iconBackground = Color("iconBackground")
    static var deviceTileBackground = Color("deviceTileBackground")
    static var textOnLightBg = Color("textOnLightBg")
    static var primaryText = Color("primaryText")
    static var label = Color("label")
    static var overlappingRectangle = Color("overlappingRectangle")
}

/**
 Decently looking background gradient (Wrap this in ZStack)
 AngularGradient(gradient: Gradient(colors: [.green, .blue, .black, .green, .blue, .black, .green]), center: .bottomTrailing)
     .ignoresSafeArea()
 */
