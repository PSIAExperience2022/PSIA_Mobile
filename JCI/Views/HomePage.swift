//
//  HomePage.swift
//  JCI
//
//  Created by Jaideep Bellani on 9/3/22.
//

import SwiftUI

struct HomePage: View {
    //I can add some variabled to change the background color
    //on connection or something like that. Thats sorta cool
    //I think having an animating symbol might be hella fkn cool,
    //Where when you unlock, it unlocks perfectly.
    @Binding var nippleCannon : Bool
    var BLEInitialization: BluetoothViewController
    var body: some View {
//        Add Johnson Controls, gradient background (Blue to green almost
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.green, .blue, .black, .green, .blue, .black, .green]), center: .center)
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Button(action: {
                        print("HYPERDRIVE ENGAGED")
                        BLEInitialization.startScanning()
                        nippleCannon.toggle()
                        //Function to toggle Cannon tazer.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            print("Hyperdrive Disengaged")
                            nippleCannon.toggle()
                        }
                    }, label: {
                        Image("JCI_LOGO_NO_BACKGROUND")
                    })
                }
                
                Spacer()
                    .frame(height: 50)
                
                VStack(spacing: 20) {
                    Button("Connect") {
                        print("This is a test for connection")
                        BLEInitialization.startScanning()
                    }
                    .clipShape(Capsule())
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    
                    Button("Disconnect", role: .destructive) {
                        print("This is testing Disconnect")
                        BLEInitialization.stopScanning()
                        BLEInitialization.disconnectPeripheral()
                    }
                    .clipShape(Capsule())
                    .buttonStyle(.bordered)
                    .foregroundColor(.red)
                    .font(.system(size: 15))
                }
                .animation(.easeInOut(duration: 10), value: 1)
            }
        }
    }
}
