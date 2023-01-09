//
//  GIFView.swift
//  JCI
//
//  Created by Jaideep Bellani on 9/4/22.
//

import Foundation
import SwiftUI
//import WebKit

//struct GifImage: UIViewRepresentable {
//    private let name: String
//    let webView = WKWebView()
//    
//    init(_ name: String) {
//        self.name = name
//    }
//    func makeUIView(context: Context) -> WKWebView {
//
//        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
//        let data = try! Data(contentsOf: url)
//        
//        self.webView.translatesAutoresizingMaskIntoConstraints = false
//        self.webView.leadingAnchor.constraint(equalTo: self.webView.leadingAnchor, constant: 0).isActive = true
//        
//        self.webView.trailingAnchor.constraint(equalTo: self.webView.trailingAnchor, constant: 0).isActive = true
//        
//        self.webView.topAnchor.constraint(equalTo: self.webView.topAnchor, constant: 0).isActive = true
//        self.webView.bottomAnchor.constraint(equalTo: self.webView.bottomAnchor, constant: 0).isActive = true
//        
//        self.webView.isOpaque = false
//        
//        webView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
//        
//        return webView
//    }
//    
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//        uiView.reload()
//    }
//}
//
//struct GifImage_Preview: PreviewProvider {
//    static var previews: some View {
//        GifImage("hyperdrive")
//    }
//}
