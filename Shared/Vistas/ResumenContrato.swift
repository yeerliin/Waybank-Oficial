//
//  ResumenContrato.swift
//  Waybank
//
//  Created by yerlin on 2/4/22.
//

import SwiftUI

struct ResumenContrato: View {
    @StateObject var simulacionContrato = FirebaseViewModel()
    var capital : String
    var temporalidad = ""
    var porcentaje = ""
    var añosVencimiento = 0
    var freq = 0
    @State private var showAlerta = false
    @Binding var isActiveLink : Bool
    @State var isActiveLinkDos = false
    
    var body: some View {
        ZStack {
            let capitalInicial = Double(capital)!
            let resultadoRendimiento = Double(capital)! * Double(porcentaje)! / 100
            let resultadoTotal = Double(capital)! + resultadoRendimiento
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .bottom, endPoint: .center).edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Text("RESUMEN CONTRATO").bold().font(.system(size: 12)).foregroundColor(.black)
                    Spacer()
                }.padding(.vertical, 4)
                VStack(spacing: 6) {
                    HStack{
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(capitalInicial, specifier: "%.2f")€").bold().font(.system(size: 15))
                            Text("Capital inicial")
                            Text("\(Date().addYear(n: añosVencimiento).formatDate())").bold().font(.system(size: 15))
                            Text("Fecha vencimiento")
                            Text("\(temporalidad)").bold().font(.system(size: 15))
                            Text("Frecuencia de disponibilidad")
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4){
                           
                            Text("\(resultadoRendimiento, specifier: "%.2f")€ ").bold().font(.system(size: 15))
                            Text("Rendimiento")
                            Text("\(porcentaje)").bold().font(.system(size: 15))
                            Text("% T.A.E")

                        }
                    }
                    VStack {
                        
                        Text("\(resultadoTotal, specifier: "%.2f")€ ").bold().font(.system(size: 25))
                        Text("SALDO TOTAL").font(.system(size:10))
                    }.padding()
                   
                    HStack{
                        
                        
                        Button {
                            
                            showAlerta = true
                            
                        } label: {
                            Text("CONTRATAR").bold().padding().background(Color.blue).cornerRadius(8)
                                .shadow(radius: 8).foregroundColor(.white).font(.system(size:18))
                        }
                        .alert(isPresented: $showAlerta)  {
                            Alert(title: Text("ALTA CONTRATO"), message: Text("¿Deseas confirmar el alta de este contrato?"), primaryButton: .destructive(Text("CANCELAR"), action: {
                                print("cancelando")
                            }),secondaryButton: .default(Text("ACEPTAR"), action: {
                                print("aceptar")
                                
                                simulacionContrato.creacionContrato(TIN: Double(porcentaje)!, cantidadInvertida: capitalInicial, comisionReseller: 0.0, estadoOperacion: "Pendiente", fechaMovimiento: Date(), frecuenciaInteres: "\(temporalidad)", idContrato: "\(Date().timeIntervalSince1970.rounded().cleanValue)", interes: 0.0, periodoInversion: freq, reinvertir: false, smartContract: "") { done in
                                    if done {
                                        
                                        isActiveLinkDos = true
                                    }
                                }
                            }
                                                        ))
                        }
                        Button {
                            //
                        } label: {
                            Text("VOLVER").bold().padding().background(Color.red).cornerRadius(8)
                                .shadow(radius: 8).foregroundColor(.white).font(.system(size:18))
                        }
                    }
                    
                }.padding().background(Color("ColorFondoTabla")).cornerRadius(8).font(.system(size:12)).shadow(radius: 8).foregroundColor(.black)
                VStack {
                    Text("DETALLE RENDIMIENTO Y RETORNO INVERSIÓN").bold().font(.system(size:12))
                    Text("Fechas en las que se te ingresarán los intereses de tu inversión.").font(.system(size:10))
                }.foregroundColor(.black).padding(.vertical, 4)
            }
        }.task {
           // simulacionContrato.getDatosInteres()
        }
    }
}
