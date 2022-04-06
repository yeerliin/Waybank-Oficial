//
//  Menu.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import SwiftUI

struct Menu: View {
    @State var seguridadShow = false
    @State var showAlertSoporte = false
    @State var isActivoSoporte = false
    @ObservedObject var datosProfileFirebase = FirebaseViewModel()
    @State var isActiveLink = false
    
    
    var body: some View {
       
            HStack{
                NavigationLink(destination: Simulador(frequenciaEnum: .trimestral)) {
                       menuBotones(nombre: "Nuevo \nContrato", icono: "plus.circle.fill").toolbar {
                            ToolbarItem(placement: .principal) {
                               logowaybank()
                                    }
                                }
                            }.padding(.horizontal, 5)
                     NavigationLink(destination: SeguridadLegal()) {
                                menuBotones(nombre: "Seguridad \nGarantias", icono: "building.columns.fill")
                            }.padding(.horizontal, 5)
                    NavigationLink(destination: Ajustes()) {
                                menuBotones(nombre: "Perfil \nKYC", icono: "person.fill")
                            }.padding(.horizontal, 5)
                    NavigationLink(destination: Soporte(), isActive: $isActivoSoporte) {
                                menuBotonSoporte(nombre: "Soporte \n24/7", icono: "iphone.homebutton.circle.fill", showAlertSoporte: $showAlertSoporte)
                            }
                            .alert("SOPORTE 24/7", isPresented: $showAlertSoporte, actions: {
                                Button("ACEPTAR",role: .cancel, action: {
                                    self.verificacionDeSoporte()
                                })
                                Button("CANCELAR", role:.destructive, action: {
                                    
                                })
                                }, message: {
                                    
                                        Text("¿Desea contactar por Chat con Soporte al Cliente? \n\nEn caso de no ser atendido en 30 segundos podrás dejar un ticket con tu número de teléfono y te llamaremos nosotros.")
                            })
                    .padding(.horizontal, 5)
            }.padding()
        }
    func verificacionDeSoporte() {
        DispatchQueue.main.async {
            self.isActivoSoporte = true
        }
    }
        
}



struct menuBotonSoporte: View {
    var nombre = "Security"
    var icono = "shield"
    @Binding var showAlertSoporte : Bool
    var body: some View {
        Button {
            showAlertSoporte = true
        } label: {
            VStack {
                Image(systemName: icono).font(.title)
                Text(nombre).font(.caption2)
            }
            
        }.frame(minWidth: 75, alignment: .center).foregroundColor(Color("ColorFondoGris"))
    }
}

struct menuBotones: View {
    var nombre = "Security"
    var icono = "shield"
    var body: some View {
        VStack {
            Image(systemName: icono).font(.title)
            Text(nombre).font(.caption2)
            
        }.frame(minWidth: 75, alignment: .center).foregroundColor(Color("ColorFondoGris"))
    }
}
