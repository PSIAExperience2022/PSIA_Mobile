//
//  Signup View.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import SwiftUI

struct SignupView: View {
    
    @State var email: String = ""
    @State var password1: String = ""
    @State var password2: String = ""
    @State var passwordSecure1: Bool = false
    @State var passwordSecure2: Bool = false
    @State var passwordsMatch: Bool = true
    
    @Binding var showLogin: Bool
    
    func handleSignup() {
        print("Going into signup flow")
        let auth = AuthData(username: self.email, password: self.password1)
        
        // Save 'auth' object to keychain
        let result = KeychainHelper.standard.saveToKeychain(auth, service: KeychainHelper.KeychainService, account: KeychainHelper.KeychainAccount)
        if(result) {
            print("Auth token saved successfully")
            showLogin = true
        } else {
            print("Auth token saving failed :(")
        }
    }
    
    func handleSignIn() {
        showLogin = true
    }
    
    var body: some View {
        ZStack {
            Color.primaryBackground.ignoresSafeArea()
            VStack {
                Group {
                    Image("PSIAExperience")
                        .resizable()
                        .frame(width: 220, height: 130, alignment: .top)
                }
                .padding(.top, 30)
                
                Spacer()
                    .frame(height: 100)
                
                // MARK: - Log in input text boxes
                Group {
                    VStack {
                        Text("Sign Up")
                            .bold()
                            .foregroundColor(Color.textSecondaryColor)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
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
                        
                        SecureInputView("Password", text: $password1, isSecure: $passwordSecure1)
                            .padding(.bottom, 4)
                        SecureInputView("Re-enter Password", text: $password2, isSecure: $passwordSecure2)
                        
                        HStack {
                            Text(" ")
                            if password2.count > 4 && password1.count == password2.count && password1 != password2 {
                            Spacer()
                            Text("Passwords don't match")
                                .padding()
                                .padding(.top, -5)
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            }
                        }
                        
                        Button(action: {
                            handleSignup()
                        }, label: {
                            Text("Sign Up")
                                .padding(18)
                                .padding(.horizontal, 80)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .overlay(RoundedRectangle(cornerRadius: 1)
                                    .stroke(Color.blue, lineWidth: 2)
                                )
                                .cornerRadius(10)
                        })
                        .padding(.top, 20)
                        .disabled(self.email.count < 4 && self.password1.count < 5 && self.password2.count < 5)
                    } .padding()
                }
                
                Spacer()
                
//                // MARK: - Other sign in options
//                LabelledDivider(label: "or")
//                HStack {
//                    // Sign in with Gmail
//                    Button(action: {
//                        handleSocialLogin()
//                    }, label: {
//                        SignInWithProviderView(label: "Gmail", logoLabel: "GoogleLogo", systemImage: nil)
//                    })
//                    Spacer()
//                        .frame(width: 20)
//                    // Sign in with FaceID
//                    Button(action: {
//                        handleFaceIDLogin()
//                    }, label: {
//                        SignInWithProviderView(label: "FaceID", logoLabel: nil, systemImage: "faceid")
//                    })
//                }
//
//                Spacer()
                
                // MARK: - Register if no account
                Button(action: {
                    handleSignIn()
                }, label: {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.white)
                        Text("Log In")
                    }
                })
            }
        }
    }
}

struct SignupViewHelper_Previews: View {
    @State var binding: Bool = false
    var body: some View {
        SignupView(showLogin: $binding)
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupViewHelper_Previews()
    }
}
