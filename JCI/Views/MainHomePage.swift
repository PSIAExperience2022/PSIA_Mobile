//
//  MainHomePage.swift
//  JCI
//
//  Created by Jaideep Bellani on 9/6/22.
//

import SwiftUI

struct MainHomePage: View {
    @State var nippleCannon : Bool = false
    var BLEInitialization = BluetoothViewController()
    var body: some View {
//        if(nippleCannon == true) {
//            //GifImage("hyperdrive")
//            Text("There was a cool gif here!")
//        }
//        else {
            HomePage(nippleCannon: $nippleCannon, BLEInitialization: BLEInitialization)
//        }
    }
}

struct MainHomePage_Previews: PreviewProvider {
    static var previews: some View {
        MainHomePage()
    }
}
