//
//  SlideToUnlock.swift
//  Sapphire Companion
//
//  Created by Nihir Singh on 2/4/23.
//
import SwiftUI

/*
 This is the entity binding all draggable components together to create the slider
 switch. This renders the slider along with a rectangle background.
 */
struct SlideToUnlock: View {
    @Binding var isLocked: Bool
    var isLoading: Bool
    @Binding var hasEnded: Bool
    var completionHandler: (Int) -> Void
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack(alignment: .leading) {
                DraggingComponentBackgroundLock(isLocked: isLocked)
                DraggingComponent(maxWidth: geometry.size.width - 40, isLocked: $isLocked, hasEnded: $hasEnded, completionHandler: completionHandler, isLoading: isLoading)
                    .padding()
                if !isLocked {
                    DraggingComponentBackgroundUnlock()
                }
            }
        }
        .frame(height: 90)
    }
}


struct SlideToUnlockPreviewHelper: View {
    @State var isLocked = true
    @State var isLoading = false
    @State var hasEnded = false
    
    var body: some View {
        SlideToUnlock(isLocked: $isLocked, isLoading: isLoading, hasEnded: $hasEnded, completionHandler: {_ in })
    }
}

struct SlideToUnlock_Preview: PreviewProvider {
    static var previews: some View {
        SlideToUnlockPreviewHelper().preferredColorScheme(.dark)
    }
}
