//
//  Soporte.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//


import SwiftUI
import WebKit

struct Soporte: View {
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .bottom, endPoint: .center).edgesIgnoringSafeArea(.all)
            VStack {
                
                WebView(peticion: URLRequest(url: URL(string: "https://jbhfinancial.ladesk.com/scripts/inline_chat.php?cwid=t40m0jsp")!))
            }
        }.navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
    }
}


struct WebView : UIViewRepresentable {
    let peticion: URLRequest
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(peticion)
    }
}
