//
//  WebViewContratos.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import SwiftUI

struct WebViewContratos: View {
    var smartContracts = ""
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .bottom, endPoint: .center).edgesIgnoringSafeArea(.all)
            VStack {
                if smartContracts == "" {
                    Text("Contrato en creación...")
                }else {
                    WebView(peticion: URLRequest(url: URL(string: smartContracts) ?? URL(string: "")!))
                }
                
            }
        }.navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
        
    }
}
