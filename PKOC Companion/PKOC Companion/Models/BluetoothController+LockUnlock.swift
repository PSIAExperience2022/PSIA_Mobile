//
//  BluetoothController+LockUnlock.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 2/7/23.
//

import Foundation

extension BluetoothController {
    
    /*
     Unlock the connected device aka start the unlock procedure which includes receiving none,
     signing it with the private key generated and then sending the signature back to the lock
     */
    func unlockDevice () {
        // Generating "unlock" command expected by the reader
        let hexVal = Data(hex: "12")
        print(hexVal)
        
    }
}

extension Data {
    func hexEncodedString1() -> String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}


//public extension Data {
//    private static let hexAlphabet = Array("0123456789abcdef".unicodeScalars)
//    func hexStringEncoded() -> String {
//        String(reduce(into: "".unicodeScalars) { result, value in
//            result.append(Self.hexAlphabet[Int(value / 0x10)])
//            result.append(Self.hexAlphabet[Int(value % 0x10)])
//        })
//    }
//}
