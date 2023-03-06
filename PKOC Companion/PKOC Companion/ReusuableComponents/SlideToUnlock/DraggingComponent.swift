//
//  DraggingComponent.swift
//  PKOC Companion
//
//  Created by Nihir Singh on 1/25/23.
//
import SwiftUI

/*
 Reusuable Dragable Slider that is used for providing lock/unlock input along with rendering user prompts for usage.
 This creates a slider switch of provided maxWidth dimension. It supports lock and unlock logic.
 On completion of an input, the completionHandler is invoked with the corresponding value. Parent must handle this
 value as needed.
 
 TODO: Need to implement a loading functionality
 */
struct DraggingComponent: View {
    let maxWidth: CGFloat
    
    private let minWidth = CGFloat(60)
    @State private var width =  CGFloat(60)
    @Binding var isLocked: Bool
    @Binding var hasEnded: Bool
    var completionHandler: (Int) -> Void
    var isLoading: Bool
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(Color.slideToUnlockBackground)
            .frame(width: width)
            .overlay(
                ZStack {
                    Group {
                        image(name: "lock", isShown: isLocked && !isLoading)
                        image(name: "lock.open", isShown: !isLocked && !isLoading)
                    }
                    
                }, alignment: .trailing
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        //print("maxWidth: \(maxWidth)")
                        //print(value.translation.width)
                        //self.hasEnded = true
//                        print("maxWidth: \(maxWidth)")
//                        print(value.translation.width)
                        if isLocked &&  value.translation.width < 0 {
                            print("Value received is negative, returning")
                            return
                        } else if !isLocked && value.translation.width > 0 {
                            print("Value received is positive, returning")
                            return
                        }
                        if isLocked && value.translation.width > 0 {
                            width = min(max(value.translation.width + minWidth, minWidth), maxWidth)
                        } else {
                            width = max(min(maxWidth + value.translation.width, maxWidth), minWidth)
                        }
                    }
                    .onEnded { value in
                        if isLocked {
                            if width < maxWidth {
                                width = minWidth
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            } else {
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                completionHandler(0)    // 0 for Unlocked
                                withAnimation(.spring()) {
                                    isLocked = false
                                    hasEnded = true
                                }
                            }
                        } else {
                            if width > minWidth {
                                width = maxWidth
                                UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            } else {
                                self.hasEnded = true
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                completionHandler(1)    // 1 for Locked
                                withAnimation(.spring()) {
                                    isLocked = true
                                    hasEnded = true
                                }
                            }
                        }
                    }
            )
            .animation(.spring(response: 0.2, dampingFraction: 1, blendDuration: 0), value: width)
    }
    
    private func image(name: String, isShown: Bool) -> some View {
        Image(systemName: name)
            .font(.system(size: 30, weight: .regular, design: .rounded))
            .foregroundColor(Color.textOnLightBg)
            .frame(width: 60, height: 60)
            .background(RoundedRectangle(cornerRadius: 20).fill(Color.primaryText))
            .opacity(isShown ? 1 : 0)
            .scaleEffect(isShown ? 1 : 0.01)
    }
}

struct DraggingComponentBackgroundLock: View {
    let isLocked: Bool
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.slideToUnlockBackground.opacity(1))
            
            if isLocked {
                HStack {
                    Text("Swipe to unlock")
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity)
                        .padding(.leading, 100)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 28))
                        .fontWeight(.light)
                        .padding(.trailing, -5)
                        .foregroundColor(Color.gray)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 28))
                        .fontWeight(.light)
                        .padding(.trailing, 40)
                        .foregroundColor(Color.primaryText)
                }
            }
        }
    }
}

struct DraggingComponentBackgroundUnlock: View {
    var body: some View {
        ZStack(alignment: .leading) {
            
//            HStack {
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 28))
//                    .fontWeight(.light)
//                    .padding(.leading, 70)
//                    .foregroundColor(Color.primaryText)
//                Image(systemName: "chevron.left")
//                    .font(.system(size: 28))
//                    .fontWeight(.light)
//                    .foregroundColor(Color.gray)
//                Text("Swipe to lock")
//                    .zIndex(13)
//                    .font(.title3)
//                    .fontWeight(.light)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding(.trailing, 100)
//            }
        }
    }
}
