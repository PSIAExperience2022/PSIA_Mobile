//
//  Login View.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/23/23.
//

import SwiftUI

struct LoginView: View {
    
    @State private var authData: AuthData? = nil
    
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordSecure: Bool = false
    @State var incorrectCredential: Bool = false
    @State var resetPwdIncorrect: Bool = false      // Flag to show prompt if faceID failed b4 resetting pwd
    @Binding var showLogin: Bool
    
    func handleForgotPassword() {
        AuthenticationManager.faceIDAuthenticate() { result in
            switch result {
            case .failure(let error):
                print("ERROR: Resetting pwd: \(error)")
                resetPwdIncorrect = true
            case .success(_):
                // TODO: Perform Forgot Pwd Flow
                print("TODO: FORGOT PWD")
                resetPwdIncorrect = false
            }
        }
    }
    
    func loadAuthData() {
        let result = KeychainHelper.standard.readFromKeychain(service: KeychainHelper.KeychainService, account: KeychainHelper.KeychainAccount, type: AuthData.self)
        authData = result
    }
    
    /*
     Handles the login flow
     If the login is successful, then a UUID token is created and stored in the device memory,
     until the user logs out / until a certain time period
     
     Function also updates the AppManager's authenticated variable with the expected value
     */
    func handleLogIn() {
        guard let authDataVal = authData else {
            print("Authentication Failed")
            incorrectCredential = true
            print("Possibly you dont have an account with us")
            return
        }
        if email == authDataVal.username && password == authDataVal.password {
            print("Authentication successful")
            AuthenticationManager.generateAndSendPublishKey() { result in
                if result {
                    AuthenticationManager.isUserAuthenticated.send(true)
                } else {
                    print("Secure public and private key generation error, loggin you out sorry")
                    AuthenticationManager.isUserAuthenticated.send(false)
                }
            }
        }
    }
    
    func handleFaceIDLogin() {
        
        print("Handling FaceID Login")
        AuthenticationManager.faceIDAuthenticate() { result in
            switch result {
            case .failure(let error):
                print("ERROR: \(error)")
            case .success(_):
                print("FaceID Authentication Successful")
                AuthenticationManager.generateAndSendPublishKey() { result in
                    if result {
                        AuthenticationManager.isUserAuthenticated.send(true)
                    } else {
                        print("Secure public and private key generation error, loggin you out sorry")
                        AuthenticationManager.isUserAuthenticated.send(false)
                    }
                }
            }
        }
    }
    
    func handleSocialLogin() {
        print("TODO: Handle Social Login")
    }
    
    func handleRegister() {
        showLogin = false
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
//                    .frame(height: 100)
                
                if resetPwdIncorrect {
                    Text("Some form of authentication is required to reset Password")
                        .frame(maxWidth: 250)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.bottom, -10)
                        .padding(.top, -50)
                }
                
                // MARK: - Log in input text boxes
                Group {
                    VStack {
                        Text("Log In")
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
                        
                        SecureInputView("Password", text: $password, isSecure: $passwordSecure)
                        
                        HStack {
                            if incorrectCredential {
                                Text("Invalid Credentials")
                                    .padding(.top, -5)
                                    .foregroundColor(.red)
                                    .fontWeight(.semibold)
                            }
                            
                            Button(action: {
                                handleForgotPassword()
                            }, label: {
                                Text("Forgot Password ?")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding()
                                    .padding(.top, -5)
                        })
                        }
                        
                        Button(action: {
                            handleLogIn()
                        }, label: {
                            Text("Log In")
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
                        .disabled(self.email.count < 4 && self.password.count < 5)
                    } .padding()
                }
                
                Spacer()
                
                // MARK: - Other sign in options
                LabelledDivider(label: "or")
                HStack {
                    // Sign in with Gmail
                    Button(action: {
                        handleSocialLogin()
                    }, label: {
                        SignInWithProviderView(label: "Gmail", logoLabel: "GoogleLogo", systemImage: nil)
                    })
                    Spacer()
                        .frame(width: 20)
                    // Sign in with FaceID
                    Button(action: {
                        handleFaceIDLogin()
                    }, label: {
                        SignInWithProviderView(label: "FaceID", logoLabel: nil, systemImage: "faceid")
                    })
                }
                
                Spacer()
                
                // MARK: - Register if no account
                Button(action: {
                    handleRegister()
                }, label: {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        Text("Register")
                    }
                })
            }
        }.onAppear() {
            loadAuthData()
        }
    }
}

struct LoginViewHelper_Preview: View {
    @State var binding: Bool = true
    var body: some View {
        LoginView(showLogin: self.$binding)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginViewHelper_Preview().preferredColorScheme(.dark).environmentObject(AuthenticationManager())
    }
}
