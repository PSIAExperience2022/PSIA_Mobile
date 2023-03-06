//
//  LottieView.swift
//  Use to define lottie animations. To use in your view, follow this pattern: LottieView(lottieFile: {name_of_JSON_file}, speed: CGFLoat (default is 1) )
//
//  Created by Hunter Goff on 1/26/23.
//

import SwiftUI
import Lottie
 
struct LottieView: UIViewRepresentable {
    let lottieFile: String
    let speed: CGFloat
    let loopMode: LottieLoopMode
    let reverse: Bool
 
    let animationView = LottieAnimationView()
 
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        
        if reverse {
            animationView.play(fromProgress: 1, toProgress: 0, loopMode: .playOnce) {_ in }
        }
        else {
            animationView.play()
        }
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}
