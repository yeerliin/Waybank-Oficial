//
//  Ajustes.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import SwiftUI
import Firebase

struct Ajustes: View {
    @State var showAlertSoporte = false
    @State var isActivoSoporte = false
    @ObservedObject var datosCrypto = FirebaseViewModel()
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            VStack{
                VStack(alignment: .leading){
                    IdReseller(datosFirebase: datosCrypto)
                    if datosCrypto.datosDelUsuario.email!.isEmpty {
                        Text((Auth.auth().currentUser?.email) ?? "Sin Correo")
                    }else {
                        Text(datosCrypto.datosDelUsuario.correoelectronico!)
                    }
                   
                }
                
                NavigationLink(destination: Home()) {
                    menuBotonesHorizontal(nombre: "Datos Personales (KYC)", icono: "person.fill")
                }.padding(.horizontal, 5)
                NavigationLink(destination: MiBanco()) {
                    menuBotonesHorizontal(nombre: "Mi Banco", icono: "building.columns.fill")
                       }.padding(.horizontal, 5)
                NavigationLink(destination: Soporte(), isActive: $isActivoSoporte) {
                    menuBotonSoporteHorizontal(nombre: "Soporte 24/7", icono: "iphone.homebutton.circle.fill", showAlertSoporte: $showAlertSoporte).foregroundColor(.black)
                    .alert("SOPORTE 24/7", isPresented: $showAlertSoporte, actions: {
                            Button("ACEPTAR",role: .cancel, action: {
                                self.verificacionDeSoporte()
                            })
                            Button("CANCELAR", role:.destructive, action: {
                                
                            })
                            }, message: {
                                
                                    Text("¿Desea contactar por Chat con Soporte al Cliente? \n\nEn caso de no ser atendido en 30 segundos podrás dejar un ticket con tu número de teléfono y te llamaremos nosotros.")
                        })}
                .padding(.horizontal, 5)
                
                botonCerrarSesion().frame(maxWidth: .infinity).padding().background(Color("ColorPrincipal")).cornerRadius(8)
                        .foregroundColor(Color("ColorCerrado"))
                        .font(.headline)
                        .padding()
                    
                
                Spacer()
            }.foregroundColor(Color("ColorFondoGris"))
            
        }.background(Color("ColorFondoGris"))
            .navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.black)
            .task {
                
                datosCrypto.getDatosUsuario()
            }
            
    }
    
    func verificacionDeSoporte() {
        DispatchQueue.main.async {
            self.isActivoSoporte = true
        }
    }
}


struct menuBotonesHorizontal: View {
    var nombre = "Security"
    var icono = "arrowtriangle.right.fill"
    var body: some View {
        HStack {
            Image(systemName: icono).font(.title2).frame(width: 25, height: 25, alignment: .center).padding(.trailing, 4)
            Text(nombre).font(.system(size: 14))
            Spacer()
            Image(systemName: "arrowtriangle.right.fill").font(.system(size: 10))
        }.padding().frame(minWidth: 30, alignment: .center).foregroundColor(Color("ColorFondoGris"))
    }
}

struct menuBotonSoporteHorizontal: View {
    var nombre = "Security"
    var icono = "arrowtriangle.right.fill"
    @Binding var showAlertSoporte : Bool
    var body: some View {
        Button {
            showAlertSoporte = true
        } label: {
            HStack {
                Image(systemName: icono).font(.title2).frame(width: 25, height: 25, alignment: .center).padding(.trailing, 4)
                Text(nombre).font(.system(size: 14))
                Spacer()
                Image(systemName: "arrowtriangle.right.fill").font(.system(size: 10))
            }
        }.padding().frame(minWidth: 30, alignment: .center).foregroundColor(Color("ColorFondoGris"))
    }
}

struct kycVerificadorAjustes: View {
    var iconokyccorrecto = "checkmark.shield.fill"
    var iconokycerror = "xmark.shield.fill"
    var datosKYC : DatosUsuarios
    var body: some View {
        
        HStack{
            if datosKYC.kyc == true {
                HStack {
                    Image(systemName: iconokyccorrecto)
                    Text("Verificación avanzada completa").font(.system(size: 10)).multilineTextAlignment(.center)
                }.padding(6)
                    .padding(.trailing, 15)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.green)).foregroundColor(.white)
            } else {
                HStack {
                    Image(systemName: iconokyccorrecto)
                    Text("Sin verificación avanzada").font(.system(size: 10)).multilineTextAlignment(.center)                }.padding(6)
                    .padding(.trailing, 15)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.red)).foregroundColor(.white)
            }
        }
        
    }
}
