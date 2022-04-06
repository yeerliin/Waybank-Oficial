//
//  Mibanco.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//
//
import SwiftUI

struct MiBanco: View {
    @StateObject var guardarDelBanco = FirebaseViewModel()
    @ObservedObject var datosFirebase = FirebaseViewModel()
    
    init(){
            UITableView.appearance().backgroundColor = .clear
        }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            VStack{
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                    Text("DATOS DE COBRO").bold().font(.system(size: 14)).foregroundColor(Color("ColorFondoGris"))
                        
                    }
                    Text("Rellene los datos bancarios donde desea recibir sus fondos.").font(.system(size: 12)).foregroundColor(Color("ColorFondoGris"))
                   
                }.padding(.vertical, 4).padding(.horizontal)
           
                 Form{
                    Section {
                        HStack {
                            TextField("Nombre del titular", text: $datosFirebase.datosDelUsuario.titular)
                           
                        }
                    } header: {
                        Text("TITULAR DE LA CUENTA:")
                    }
                   
                    Section {
                        HStack {
                            TextField("Nombre del banco:", text: $datosFirebase.datosDelUsuario.banco)
                        }
                    } header: {
                        Text("NOMBRE DEL BANCO:")
                    }
                    
                    Section {
                        HStack {
                            TextField("Numero iban:", text: $datosFirebase.datosDelUsuario.iban)
                        }
                    } header: {
                        Text("IBAN:")
                    }
                    
                    Section {
                        HStack {
                            TextField("Codigo Swift:", text: $datosFirebase.datosDelUsuario.swift)
                        }
                    } header: {
                        Text("SWIFT:")
                    }
                    
                    
                }.navigationBarItems(trailing: logowaybank())
                    .navigationBarTitleDisplayMode(.inline)
               
                Button {
                    guardarDelBanco.DatosDelBanco(titular: datosFirebase.datosDelUsuario.titular, banco: datosFirebase.datosDelUsuario.banco, iban: datosFirebase.datosDelUsuario.iban, swift: datosFirebase.datosDelUsuario.swift) { done in
                    }
                } label: {
                    HStack {
                        Text("GUARDAR CAMBIOS").foregroundColor(.white)
                    }   .frame(maxWidth: .infinity)
                        .padding().background(Color("ColorPrincipal"))
                }
                
            }
                .font(.system(size: 12))
                .foregroundColor(Color.black)
                .edgesIgnoringSafeArea(.bottom)
              
    }.task {
        datosFirebase.getDatosUsuario()
    }
            
    }
}
