//
//  ContentView.swift
//  Shared
//
//  Created by yerlin on 28/3/22.
//

import SwiftUI

struct ContentView: View {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @AppStorage("log_status") var log_Status = false
    @EnvironmentObject var loginShow : FirebaseViewModel
    var body: some View {
        return Group {
            if loginShow.showLogin || log_Status || viewModel.state == .signedIn {
                Dashboard()
                    .edgesIgnoringSafeArea(.all)
                    
            }else{
                InicioSesion()
            }
        }.onAppear {
            if (UserDefaults.standard.object(forKey: "sesion")) != nil {
                log_Status = true
                loginShow.showLogin = true
                viewModel.state = .signedIn
            }
        }
        
    }
}
