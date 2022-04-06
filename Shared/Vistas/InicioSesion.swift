//
//  InicioSesion.swift
//  Waybank
//
//  Created by yerlin on 28/3/22.
//

import SwiftUI
import Firebase
import AuthenticationServices
import GoogleSignIn

struct InicioSesion: View {
    @State private var email = "test1@gmail.com"
    @State private var pass = "patata1234"
    @StateObject var login = FirebaseViewModel()
    
    //EMAIL + PASS LOGIN
    @EnvironmentObject var loginShow : FirebaseViewModel
    
    //IOS LOGIN
    @StateObject var loginData = LoginViewModel()
    
    //GOOGLE LOGIN
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    
    var device = UIDevice.current.userInterfaceIdiom
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            VStack{
                WaybankLogo().frame(width: device == .pad ? 350 : nil)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .frame(width: device == .pad ? 400 : nil)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Contraseña", text: $pass)
                    .frame(width: device == .pad ? 400 : nil)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button {
                    login.login(email: email, password: pass) { done in
                        if done {
                            UserDefaults.standard.set(true,forKey: "sesion")
                            loginShow.showLogin.toggle()
                        }
                    }
                } label:    {
                    Text("ACCEDER")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .background(Color.red)
                            }
                HStack {
                    VStack {
                        Divider().foregroundColor(.black)
                    }
                    Text("Iniciar sesion con")
                    VStack {
                        Divider().foregroundColor(.black)
                    }
                }
                HStack{
                    
                    //Boton para Registrar un uusuario nuevo con sus archivos en la base de datos.
                    Button {
                        login.crearUsuario(password: pass, Apellidos: "", Banco: "", CP: "", Descripcion: "", DescripcionFondos: "", Direccion: "", DireccionBanco: "", DNI: "", email: email, Estado: false, EstadoCivil: "", FechaAlta: Date(), FechaBaja: Date(), FechaNacimiento: "", Iban: "", iDCliente: 3, idOficina: 2, iDReseller: 2, Idioma: "", Incremento: 1, iPAlta: "", iPUltima: "", KYC: false, Moneda: "", Nombre: "", Pais: "", Poblacion: "", Profesion: "", Provider: "", Provincia: "", RangoInversionHasta: 2, RangoInversionDesde: 2, Riesgo: 2, Sexo: "String", Swift: "", Telefono: "", Vip: false) { done in
                            if done {
                                UserDefaults.standard.set(true,forKey: "sesion")
                                loginShow.showLogin.toggle()
                            }
                        }
                    } label: {
                        Text("Registro")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 4)
                            .background(Color.red)
                    }
                    // Boton de Registro arriba ---
                    
                    HStack {
                        
                        SignInWithAppleButton { (request) in
                            
                            // requesting paramertes from apple login...
                            loginData.nonce = randomNonceString()
                            request.requestedScopes = [.email,.fullName]
                            request.nonce = sha256(loginData.nonce)
                            
                        } onCompletion: { (result) in
                            
                            // getting error or success...
                            
                            switch result{
                                case .success(let user):
                                    print("success")
                                    // do Login With Firebase...
                                    guard let credential = user.credential as? ASAuthorizationAppleIDCredential else{
                                        print("error with firebase")
                                        return
                                    }
                                    loginData.authenticate(credential: credential)
                                case.failure(let error):
                                    print(error.localizedDescription)
                            }
                        }.frame(width: 140, height: 47)
                        Button {
                            viewModel.signIn()
                        } label: {
                            GoogleSignInButton().frame(width: 140, height: 47)
                        }
                        
                    }
                    
                    // ---------------
                   
                }
                Spacer()
            }           .padding(.all)
        }
    }
}

struct WaybankLogo: View {
    var body: some View {
        Image("WaybankTextoLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 250)
            .cornerRadius(10.0)
            .shadow(radius: 5.0, x: 10, y: 10)
    }
}


