//
//  AuthenticationView.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import SwiftUI
import CryptoKit

struct AuthenticationView: View {
    @State var showLogin: Bool = true
    
    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            VStack {
                if showLogin {
                    LoginView(showLogin: $showLogin)
                } else {
                    SignupView(showLogin: $showLogin)
                }
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView().preferredColorScheme(.dark)
    }
}


struct AuthData: Codable {
    let username: String
    let password: String
}

struct KeyData: Codable {
    let publicKey: Data
    let privateKey: Data
}
