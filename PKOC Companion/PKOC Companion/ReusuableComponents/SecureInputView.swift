//
//  SecureInputView.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import SwiftUI

struct SecureInputView: View {
    static var data = "pund"
    
    @Binding private var text: String
    @State private var showPassword: Bool = false
    @Binding private var isSecure: Bool
    private var title: String
    
    init(_ title: String, text: Binding<String>, isSecure: Binding<Bool>) {
        self.title = title
        self._text = text
        self._isSecure = isSecure
    }
    var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if !showPassword {
                    SecureField(title, text: $text)
                        .padding()
                        .background(Color.textboxBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textboxStroke, lineWidth: 2)
                        )
                        .padding()
                        .padding(.bottom, -20)
                        .foregroundColor(.white)
                } else {
                    TextField(title, text: $text)
                        .padding()
                        .background(Color.textboxBackground)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.textboxStroke, lineWidth: 2)
                        )
                        .padding()
                        .padding(.bottom, -20)
                        .foregroundColor(.white)
                }
                
                Button(action: {
                    showPassword.toggle()
                }, label: {
                    Image(systemName: self.showPassword ? "eye.slash" : "eye")
                        .font(.system(size: 23))
                        .accentColor(.textSecondaryColor)
                        .padding(.trailing, 30)
                        .padding(.top, 15)
                })
            }
        }
    }
}

struct middleLayer: View {
    @State private var pund = "wowowow"
    @State private var brexit = true
    var body: some View {
        SecureInputView("Pund", text: $pund, isSecure: $brexit)
    }
}

struct SecureInputView_Previews: PreviewProvider {
    static var previews: some View {
        middleLayer().preferredColorScheme(.dark)
    }
}
