//
//  Dashboard.swift
//  Waybank
//
//  Created by yerlin on 28/3/22.
//

import SwiftUI
import Firebase
import UIKit

struct Dashboard: View {
    
    //Variables para la informacion del usuario
    @State var sumaCapital = 0.0
    @State var sumaRendimiento = 0.0
    @State var sumaTotal = 0.0
    
    //Peticiones para la base de datos
    @ObservedObject var datosFirebase = FirebaseViewModel()
    @EnvironmentObject var loginShow : FirebaseViewModel
    @StateObject var frequenciaDuracion = SimuladorViewModel()
    
   
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
                VStack {
                    HStack(alignment: .center) {
                        VStack {
                            Text(Auth.auth().currentUser?.email ?? "Sin correo")
                            HStack{
                                VStack(alignment: .leading){
                                    Text((datosFirebase.datosDelUsuario.nombre!)  + " " + datosFirebase.datosDelUsuario.apellidos!)
                                    Button {
                                        UIPasteboard.general.string = "\((datosFirebase.datosDelUsuario.idCliente)!).\((datosFirebase.datosDelUsuario.idOficina)!).\((datosFirebase.datosDelUsuario.idReseller)!)"
                                        print(UIPasteboard.general.string!)
                                    } label: {
                                        Text("ID: \((datosFirebase.datosDelUsuario.idCliente)!).\((datosFirebase.datosDelUsuario.idOficina)!).\((datosFirebase.datosDelUsuario.idReseller)!)").font(.system(size: 12)).foregroundColor(.black)
                                        Image(systemName: "doc.on.doc").font(.system(size: 12)).foregroundColor(.black)
                                    }
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("Imagen")
                                }
                            }
                            VStack {
                                Text("\(datosFirebase.getSumaTotal(sumaTotal: sumaTotal), specifier: "%.2f") €").bold().font(.system(size: 20))
                                Text("SALDO TOTAL").font(.system(size: 12))
                            }.padding(.vertical, 2)
                                
                                
                            HStack {
                                Spacer()
                                VStack {
                                    Text("\(datosFirebase.getCapital(sumaCapital: sumaCapital), specifier: "%.2f") €").bold().font(.system(size: 16))
                                    Text("Capital inicial").font(.system(size: 12))
                                }.padding(.vertical, 2)
                                Spacer()
                                VStack {
                                    Text("\(datosFirebase.getRendimiento(sumaRendimiento: sumaRendimiento), specifier: "%.2f") €").bold().font(.system(size: 16))
                                    Text("Rendimiento").font(.system(size: 12))
                                }.padding(.vertical, 2)
                                Spacer()
                                
                            }
                            Text("Resumen de saldos de tus Contratos ACTIVOS").bold().font(.system(size: 10))
                        }.padding().background(RoundedRectangle(cornerRadius: 12).fill(Color("ColorFondoGris"))).padding(.horizontal, 12)
                    }.padding(.horizontal, 4).shadow(radius: 4)
                    
                    Menu().shadow(radius: 8)
                    Text("MIS CONTRATOS").bold().font(.system(size: 16))
                    ScrollView {
                        VStack{
                            ForEach(datosFirebase.contratosWaybank, id: \.idContrato){ iteam in
                                NavigationLink {
                                    PruebasDePeticiones(vistaContrato: iteam)
                                } label: {
                                    Contratos(operaciones: iteam).shadow(radius: 2)
                                }
                                
                            }
                        }
                    }
                }
            }.background(Color(.gray))
                .navigationBarTitleDisplayMode(.inline).onAppear(){
                    datosFirebase.getVerificadorDeColeccion()
                }
           
            .task {
                datosFirebase.getDatosUsuario()
                datosFirebase.getDatosContratos()
                datosFirebase.getIntereses()
            
            }
        }.accentColor(Color("ColorFondoGris"))
    }
}

