// TODO: - WILL BE REMOVED //

////
////  AppData.swift
////  PKOC Companion
////
////  Created by Nihir Singh on 1/23/23.
////
//
//import Foundation
//import LocalAuthentication
//
//class AppData: ObservableObject {
//
//
//
//    /*
//     Logs in the user
//     For now uses hard coded values, TODO: Remove hard coded values
//     */
//    static func loginUser(email: String, password: String, completionHandler: @escaping (Result<Bool, AuthenticationError>) -> Void) {
//        if email != "nihir@lastlock.com" {
//            completionHandler(.failure(AuthenticationError.IncorrectCredentials))
//            return
//        }
//        if password != "Password@123" {
//            completionHandler(.failure(AuthenticationError.IncorrectCredentials))
//            return
//        }
//        completionHandler(.success(true))
//        AppManager.Authenticated.send(true)
//        return
//    }
//
//    /*
//     Logs out the user by removing the secure "authToken" stored on the user's device
//     */
//    static func logoutUser() {
//        UserDefaults.standard.removeObject(forKey: AppManager.TokenKey)
//        AppManager.Authenticated.send(false)
//    }
//
//    static func faceIDAuthenticate(completionHandler: @escaping (Result<Bool, AuthenticationError>) -> Void) {
//        let context = LAContext()
//        var error: NSError?
//
//        // check whether biometric authentication is possible
//        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//            // it is possible to use biometric authentication, using it
//            let reason = "Need authorization to give access"
//
//            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//                // authentication has now completed
//                if success {
//                    // authenticated successfully
//                    print("User authenticated successfully")
//                    createAndStoreToken()
//                    completionHandler(.success(true))
//                    return
//
//                } else {
//                    // something fucky happened
//                    print("ERROR: authenticationError: \(authenticationError)")
//                    completionHandler(.failure(AuthenticationError.IncorrectCredentials))
//                }
//            }
//        }
//    }
//
//    private static func createAndStoreToken() {
//        let token = UUID().uuidString
//        UserDefaults.standard.set(token, forKey: AppManager.TokenKey)
//        AppManager.Authenticated.send(true)
//    }
//
//}
//
//enum AuthenticationError: Error {
//    case IncorrectCredentials
//    case LogoutFailed
//    case UnknownError
//}
//
//extension AuthenticationError: CustomStringConvertible {
//    public var description: String {
//        switch self {
//        case .IncorrectCredentials:
//            return "Incorrect email or password "
//        case .LogoutFailed:
//            return "Something went wrong while Logging out"
//        case .UnknownError:
//            return "Unknown error!"
//        }
//    }
//}
