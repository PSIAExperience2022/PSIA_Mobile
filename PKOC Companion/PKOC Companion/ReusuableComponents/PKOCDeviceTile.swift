//
//  PKOCDeviceTile.swift
//  PKOC Companion
//
//  Created by Hunter Goff on 2/27/23.
//

import SwiftUI

struct PKOCDeviceTile: View {
    var deviceName: String
    var body: some View {
        ZStack() {
            if (deviceName == "No Devices Found") {
                VStack {
                    Text("No Devices Found")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            } else {
                Rectangle()
                    .foregroundColor(Color.deviceTileBackground)
                    .cornerRadius(30)
                    .frame(maxWidth: 400, maxHeight: 100)
                HStack(alignment: .center) {
                    Image(systemName: "lock.circle.fill")
                        .foregroundStyle(Color.iconBackground, Color.primaryBackground)
                        .font(.system(size: 45))
                        .padding(20)
                    Spacer()
                    Text(deviceName)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .font(.system(size: 24))
                        .frame(maxWidth: .infinity, alignment: .leading) // lines up left side of text
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white)
                        .padding(20)
                }
                .padding()
            }
        }
    }
}

struct PKOCDeviceTile_Previews: PreviewProvider {
    static var previews: some View {
        VStack() {
            PKOCDeviceTile(deviceName: "Hardware")
            PKOCDeviceTile(deviceName: "Parking Garage")
        }.preferredColorScheme(.dark)
    }
}
