//
//  WaybankApp.swift
//  Shared
//
//  Created by yerlin on 28/3/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main

struct WaybankApp: App {
    @StateObject var viewModel = AuthenticationViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
       let loginEmailPass = FirebaseViewModel()
        WindowGroup {
            ContentView().environmentObject(loginEmailPass)
                            .environmentObject(viewModel)
        }
    }
}
