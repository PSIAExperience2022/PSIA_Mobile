//
//  ScanningView.swift
//  PKOC Companion
//
//  Created by Hunter Goff on 2/27/23.
//

import SwiftUI
import CoreBluetooth
import CryptoKit

struct ScanningView: View {
    //@EnvironmentObject var bluetoothController: BluetoothController
    @ObservedObject var bluetoothController: BluetoothController = BluetoothController()
    @State private var scanning: Bool = true
    
    func loadingTasks() {
        self.scanning = true
        bluetoothController.startScanning()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Turning BL scan off after 2 (!) seconds")
            bluetoothController.stopScanning()
            self.scanning = false
        }
    }
    
    //var values = [String](repeating: "Last Lock", count: 50)
        
    var body: some View {
        NavigationStack() {
            ScrollView {
                    VStack() {
                        Group {
                            Image("PSIAExperience")
                                .resizable()
                                .frame(width: 220, height: 130, alignment: .top)
                        }
                        .padding(.top, 40)
                        .padding(.leading, 34)
                        
                        Spacer()
                        
                        if (scanning) {
                            Text("Scanning")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                            LottieView(lottieFile: "bluetoothSearch", speed: 1, loopMode: .loop, reverse: false)
                                .scaledToFit()
                        } else if (bluetoothController.allPKOCperipherals.isEmpty) {
                            Text("No Devices Found")
                                .font(.title2)
                                .padding()
                            LottieView(lottieFile: "notFound", speed: 1, loopMode: .playOnce, reverse: false)
                                .frame(width: 350, height: 200)
                                .padding(.all)
                            Button(action: {
                                loadingTasks()
                            }) {
                                Text("Scan Again")
                                    .frame(width: 300, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 30)
                                        .fill(Color.slideToUnlockBackground)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(width: 600, height: 150, alignment: .top)
                        }
                        else {
                            ForEach(bluetoothController.allPKOCperipherals, id: \.self) { perpherial in
                                NavigationLink {
                                    HomeView(bluetoothController: bluetoothController, perpherial: perpherial)
                                } label: {
                                    PKOCDeviceTile(deviceName: perpherial.name ?? "No Devices Found")
                                }
                            }
                        }
                        Spacer()
                    }
                .onAppear() {
                    loadingTasks()
                    //print("ScanningView loaded: Clear out the Array and repopulate.")
                    bluetoothController.allPKOCperipherals.removeAll()
                }
            }
            .ignoresSafeArea()
            .background(Color.primaryBackground.ignoresSafeArea())
        }
    }
}

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView().preferredColorScheme(.dark)
    }
}
