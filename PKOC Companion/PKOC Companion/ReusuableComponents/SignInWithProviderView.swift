//
//  SignInWithProviderView.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import SwiftUI

struct SignInWithProviderView: View {
    
    let label: String
    let logoLabel: String?
    let systemImage: String?
    var body: some View {
        HStack {
            if systemImage != nil {
                Image(systemName: systemImage!)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            } else if logoLabel != nil {
                Image("GoogleLogo")
                    .resizable()
                    .frame(width: 28, height: 26)
            }
            
            Text(label)
                .foregroundColor(Color.textPrimaryColor)
        }
        .padding()
        .padding(.horizontal, 15)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.textboxStroke, lineWidth: 2)
        )
    }
}

struct SignInWithProviderView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithProviderView(label: "Google", logoLabel: "googleLogo", systemImage: nil).preferredColorScheme(.dark)
    }
}
