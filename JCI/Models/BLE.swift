//
//  BLE.swift
//  JCI
//
//  Created by Jaideep Bellani on 9/3/22.
//

/*
    This file handles most of the BLE Connection stuff in the background.
    It connects and does everything when one single connect function is called.
    I just have to choose, if I want to connect automatically or initiate connections on buttons.
 
    Also, this sort of acts like a standrd template for BLE connections in iOS.
 */
import Foundation
import CoreBluetooth
import UIKit
import SwiftUI

//TODO: Todo CheckList
//  [ ] Add Structure to store information regarding BLE
//  [ ] Add seperate Delegate classes for notifying.
//  [ ] Create state variables for better User Experience on the homepage.

//This should also probably go into the controller implementation.
class BluetoothViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    //These BLE variables could be in their own structure
    //Do these have to be private?
    //Might be a good idea to make them mandatory instead of optional.
    //I am sure it can break something.
    var centralManager: CBCentralManager?
    var PKOCperipheral: CBPeripheral?
    var connectedPKOCperipheral: CBPeripheral?
    var PKOCreadCharacteristic: CBCharacteristic?
    var PKOCwriteCharactertistic: CBCharacteristic?
    @Published var connectedToDevice: Bool = false
    
    //Changing the signed Nonce condition will make it connect or disconnect from the lock.
    let signedNonceResponse = String("Its Britney bitch - Michael Scott")
    
    //This is incorrect
    //let signedNonceResponse = String("Sometimes in life")
    
    //This is the data to send when requesting the nonce.
    var askForNonce: Int = 105
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        print("Bluetooth Central Manager Initialized.")
    }
    
    //God knows what this is for, but it seems so cool.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            switch central.state {
                case .poweredOn:
                    print("Bluetooth Powered On")
                    startScanning()
                case .poweredOff:
                    print("Bluetooth Powered Off")
                    // Alert user to turn on Bluetooth
                case .resetting:
                    print("Bluetooth Resetting")
                    // Wait for next state update and consider logging interruption of Bluetooth service
                case .unauthorized:
                    print("Unauthorized Access to Bluetooth")
                    // Alert user to enable Bluetooth permission in app Settings
                case .unsupported:
                    print("Bluetooth Access Unsupported")
                    // Alert user their device does not support Bluetooth and app will not work as expected
                case .unknown:
                    print("Unknown Error Encountered when dealing with Bluetooth.")
                   // Wait for next state update
            default:
                print("Unknown Error occured when instantiating Bluetooth.")
            }
        }
    
    //Function to Start scanning to Peripherals
    func startScanning() {
        //self.centralManager?.scanForPeripherals(withServices: [defineUUID.PKOC_Service_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
//        print(defineUUID.PKOC_Service_UUID)
//        self.centralManager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        print("Started scanning")
        self.centralManager?.scanForPeripherals(withServices: [defineUUID.PKOC_Service_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    func stopScanning() {
        print("Stopped scanning for peripherals.")
        self.centralManager?.stopScan()
    }
   
    //Function called when you actually discover the device.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //Checking if device contains the PKOC Service.
        //This could 100 percent interfere with other locks which are present around, need to find a way to fix that.
        //POSSIBLY, filter out BLE Devices by their RSSI/Strength. That should be super ideal.
        
        //Can also create struct to store device data. Might be useful later.
        //Can also show this information on the screen if it is not nil.
        //Error checking and also finding the best manner to send and receiev variables across different views.
        
        if(advertisementData["kCBAdvDataServiceUUIDs"] != nil) {
            let serviceData = advertisementData["kCBAdvDataServiceUUIDs"] as! [CBUUID]
            if(serviceData.contains(defineUUID.PKOC_Service_UUID)) {
                print(peripheral)
                //Why do we do this? No Idea, but fix it.
                if(peripheral.name == "Last Lock") {
                    self.PKOCperipheral = peripheral
                    self.PKOCperipheral?.delegate = self
                    
                    print("Discovered a PKOC Reader. NAME: \(String(describing: PKOCperipheral?.name)) | RSSI: \(RSSI)")
                    connectPKOCReader(PKOCperipheral: self.PKOCperipheral)
                }
                
            }
        }
    }
    
    /*
     *
     *      CONNECT FUNCTIONS
     *
     */
    //This function needs to be called explicitly to connect to the peripheral. I will do that.
    func connectPKOCReader(PKOCperipheral: CBPeripheral!) {
        print("Going into Connect function")
        //self.centralManager?.connect(PKOCperipheral, options: [CBConnectPeripheralOptionNotifyOnConnectionKey: "This shit just got connected. Beginning PKOC Flow"])
        self.centralManager?.connect(PKOCperipheral)
    }
    
    //(Again, for simplicity, we are using a single class to handle all delegate calls, but this isn’t the best design practice for larger codebases.)
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Successfully connected to the peripheral.")
        
        //This is when haptics are enabled.
        //HapticsManager.shared.vibrate(for: .success)
        
        // Successfully connected. Store reference to peripheral if not already done.
        self.connectedPKOCperipheral = peripheral
        print("Does this even work", self.connectedToDevice)
        
        //Very bad practice. Change it
        peripheral.delegate = self
        
        self.stopScanning()
        
        //Discover Services after connecting.
        discoverServices(PKOCperipheral: self.connectedPKOCperipheral!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect \(error)")
    }
    
    /*
     *
     *      DISCONNECT FUNCTIONS
     *
     */
    
    func disconnectPeripheral() {
        if(self.PKOCperipheral != nil) {
            self.disconnect(PKOCperipheral: self.PKOCperipheral!)
        }
        else {
            print("No device is connected right now.")
        }
    }
    
    func disconnect(PKOCperipheral: CBPeripheral) {
        self.connectedToDevice = false
        centralManager?.cancelPeripheralConnection(PKOCperipheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            // Handle error
            print("Error occured during Disconnection \(error)")
            
            //I have no idea if this is Ideal, but it could be.
            connectPKOCReader(PKOCperipheral: connectedPKOCperipheral)
            return
        }
        // Successfully disconnected
        print("Successfully disconnected from PKOC Peripheral")
    }
    
    
    /*
     *
     * DISCOVERING SERVICES
     *
     */
    func discoverServices(PKOCperipheral: CBPeripheral) {
        print("Going into Discover Services function")
        PKOCperipheral.discoverServices([defineUUID.PKOC_Service_UUID])
    }
    
    //Can I change the name to PKOC Peripheral.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let PKOCservice = peripheral.services else {
            print("Failed to Discover Services/No Services found.")
            return
        }
        
        print(PKOCservice)
        discoverCharacteristics(PKOCperipheral: peripheral)
    }
    
    /*
     *
     *  DISCOVER CHARACTERISTICS
     *
     */
    //Our service is nil, but that does not mean it isnt perfect.
    func discoverCharacteristics(PKOCperipheral: CBPeripheral) {
        print("Going into discover Characteristics Function")
        let PKOCservices = PKOCperipheral.services
        //Change the service function to something thats defined already. Static accessing is extremely bad.
        PKOCperipheral.discoverCharacteristics([defineUUID.PKOC_Write_UUID, defineUUID.PKOC_Read_UUID] ,for: (PKOCservices?[0])!)
    }
    
    //Function headers have all the information within the
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let PKOCcharacteristics = service.characteristics else {
            print("Unable to Find any characteristics within the service.")
            return
        }
        
        //Define Read and Write Characteristics and store them for safe keeping, PKOC Style.
        //Need to store these characteristics somewhere seperately. otherwise
        for characteristic in PKOCcharacteristics {
            if(characteristic.uuid == defineUUID.PKOC_Read_UUID) {
                self.PKOCreadCharacteristic = characteristic
            }
            else if(characteristic.uuid == defineUUID.PKOC_Write_UUID) {
                self.PKOCwriteCharactertistic = characteristic
            }
            else {
                print("Not a required Characteristic, where did you come from \(characteristic.uuid)")
            }
        }
        
        //Start notifying on the read characteristic after discovering the value.
        //Might be useful to use the stored peripheral credentials.
        subscribeToNotifications(PKOCperipheral: peripheral, characteristic: PKOCreadCharacteristic!)
            
            //Automatically sends nonce to device.
            //Sending Nonce Request to the device.
            //When I dont send the nonce Request.
            let hexStringNonceRequest = String(self.askForNonce, radix: 16)
            guard let dataStringNonceRequest = Data(hex: hexStringNonceRequest) else { return print("Failed to convert Data to hexString") }
            self.write(value: dataStringNonceRequest, characteristic: self.PKOCwriteCharactertistic!)
    }
    
    /*
     *  DESCRIPTOR FUNCTIONS FOR CHARACTERISTICS. NEED TO ADD FUNCTIONS FOR THIS.
     */
    //TODO: Add descriptor functions to the firmware and also to iOS Code.
    //TODO: Might be useful to find out what exactly descriptors are.
    
    
    /*
     *
     *  FUNCTION: Subscribe/Notifying functions, add Switch in handling case.
     *
     */
    //TODO: Create a function to unsubscribe from notification
    func subscribeToNotifications(PKOCperipheral: CBPeripheral, characteristic: CBCharacteristic) {
        PKOCperipheral.setNotifyValue(true, for: PKOCreadCharacteristic!)
    }
    
    // Find a manner to support and find a wa
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            // Handle error
            print("An error occured when trying to subscribe to a characteristics. \(error)")
            return
        }
        // Successfully subscribed to or unsubscribed from notifications/indications on a characteristic
        print("Subscribed to notifications on \(characteristic.uuid)")
        
        //How do I read the value after subscribing. I also think, after that, I have to write and create a flow for this PKOC.
        //Might need to figure that out soon.
    }
    
    func handleNotifications(notificationData: Data) {
        let byteArray = [UInt8](notificationData)
        print(byteArray)
        //I should parse and save the nonce for future purposes, but for now, if I recieve this request, I should just send something back.
        switch byteArray[0] {
        case 2:
            print("Handling Nonce Response from Lock")
            let dataSignedNonceResponse = Data(signedNonceResponse.utf8)
            self.write(value: dataSignedNonceResponse, characteristic: self.PKOCwriteCharactertistic!)
            self.connectedToDevice = true
            break

        case 192:
            print("Handling Nonce Response from Lock")
            let dataSignedNonceResponse = Data(signedNonceResponse.utf8)
            self.write(value: dataSignedNonceResponse, characteristic: self.PKOCwriteCharactertistic!)
            self.connectedToDevice = true
            break
        default:
            print("Going into the default case.")
            let dataSignedNonceResponse = Data(signedNonceResponse.utf8)
            self.write(value: dataSignedNonceResponse, characteristic: self.PKOCwriteCharactertistic!)
            self.connectedToDevice = true
            break
        }
    }
    // Function to read values from the characteristic.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //Still cant find a way to read the value from the
        handleNotifications(notificationData: characteristic.value!)
        //When there is an update and you get a not null value, write the signed digitalNonce to the lock and then open on the lock side.
    }
    
    
    
    /*
     *
     *  WRITING TO THE PERIPHERAL
     *
     */
    func write(value: Data, characteristic: CBCharacteristic) {
        if ((connectedPKOCperipheral?.canSendWriteWithoutResponse) != nil) {
            self.connectedPKOCperipheral?.writeValue(value, for: PKOCwriteCharactertistic!, type: .withoutResponse)
        }
    }
    
    //I think this is a callback. Otherwise
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("Is the peripheralIsReady function a callback or what is it?")
        //write(value: , characteristic: <#T##CBCharacteristic#>)
    }
    
    
    
    
    
}



extension Data {
    init?(hex: String) {
        guard hex.count.isMultiple(of: 2) else {
            return nil
        }
        
        let chars = hex.map { $0 }
        let bytes = stride(from: 0, to: chars.count, by: 2)
            .map { String(chars[$0]) + String(chars[$0 + 1]) }
            .compactMap { UInt8($0, radix: 16) }
        
        guard hex.count / bytes.count == 2 else { return nil }
        self.init(bytes)
    }
}

////Function to convert Hexadecimal String to Data object.
//// Extends to String class
///// Usage: String(hexadecimal: hexString)
//extension String {
//
//    /// Create `Data` from hexadecimal string representation
//    ///
//    /// This creates a `Data` object from hex string. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
//    ///
//    /// - returns: Data represented by this hexadecimal string.
//
//    var hexadecimal: Data? {
//        var data = Data(capacity: count / 2)
//
//        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
//        regex.enumerateMatches(in: self, range: NSRange(startIndex..., in: self)) { match, _, _ in
//            let byteString = (self as NSString).substring(with: match!.range)
//            let num = UInt8(byteString, radix: 16)!
//            data.append(num)
//        }
//
//        guard data.count > 0 else { return nil }
//
//        return data
//    }
//
//}
