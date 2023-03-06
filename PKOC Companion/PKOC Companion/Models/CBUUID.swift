//
//  CBUUID.swift
//  JCI
//
//  Created by Jaideep Bellani on 9/3/22.
//

import Foundation
import CoreBluetooth

struct defineUUID {
    static let PKOC_Service_UUID_String = "41fb60a1-d4d0-4ae9-8cbb-b62b5ae81810"
    static let PKOC_Write_UUID_String = "fe278a85-89ae-191f-5dde-841202693835"
    static let PKOC_Read_UUID_String = "e5b1b3b5-3cca-3f76-cd86-a884cc239692"
    static let PKOC_CCCD_String = "00002902-0000-1000-8000-00805f9b34fb"
    
    static let PKOC_Service_UUID = CBUUID(string: PKOC_Service_UUID_String)
    static let PKOC_Write_UUID = CBUUID(string: PKOC_Write_UUID_String)
    static let PKOC_Read_UUID = CBUUID(string: PKOC_Read_UUID_String)
    static let PKOC_Client_Characteristic_UUID = CBUUID(string: PKOC_CCCD_String)
}
