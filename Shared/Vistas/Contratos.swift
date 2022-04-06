//
//  Contratos.swift
//  Waybank
//
//  Created by yerlin on 3/4/22.
//
import SwiftUI
import Foundation

struct Contratos: View {
    
    let operaciones : DatosContratosWaybank
    var body: some View {
        
        VStack(alignment: .center){
            HistorialContratos(contratosAbiertos: operaciones).padding(.horizontal).foregroundColor(.black)
            Divider().background(.black).padding(.bottom, 4).padding(.horizontal)
               
            }
            }
        }




struct HistorialContratos: View {
    let contratosAbiertos : DatosContratosWaybank
    @State var sumaRendimiento = 0.0
    @ObservedObject var datosFirebase = FirebaseViewModel()
    var dateComponent = DateComponents()
    @State var isActivoPago = false
    var body: some View {
        //TESTEO
     HStack(spacing: 10){
         VStack(alignment: .leading, spacing: 2, content: {
                    
                    Text("Inicio contrato").font(.system(size: 10)).bold()
                    Text(contratosAbiertos.fechaMovimiento.formatDate())
                        .font(.system(size: 10))
                }).padding(.leading)
         Spacer()
         VStack(alignment: .center, spacing: 2, content: {
             Text("Estado").font(.system(size: 10)).bold()
             if contratosAbiertos.estadoOperacion == "Activo" {
                 Text(contratosAbiertos.estadoOperacion.uppercased()).font(.system(size: 10)).bold().foregroundColor(Color("ColorActivo"))
             } else if contratosAbiertos.estadoOperacion == "Pendiente" {
                 Text(contratosAbiertos.estadoOperacion.uppercased()).font(.system(size: 10)).bold().foregroundColor(Color("ColorPendiente"))
             } else {
                 Text(contratosAbiertos.estadoOperacion.uppercased()).font(.system(size: 10)).bold().foregroundColor(Color("ColorCerrado"))
             }
         })
         Spacer()
                VStack(alignment: .trailing, spacing: 2, content: {
                    let date = Calendar.current.date(byAdding: .month, value: Int(contratosAbiertos.periodoInversion), to: contratosAbiertos.fechaMovimiento)
                    Text("Fecha vencimiento").font(.system(size: 10)).bold()
                  
                    Text(date!.formatDate()).font(.system(size: 10))
                }).padding(.trailing)
         
     }.padding(.horizontal)
        VStack {
            HStack(spacing: 5){
                Spacer()
                VStack{
                    Text("Capital Inicial").font(.system(size: 10))
                    Text("\(contratosAbiertos.cantidadInvertida, specifier: "%.02f€")").font(.system(size: 12)).bold()
                }
                Spacer()
                VStack{
                    Text("Rendimiento").font(.system(size: 10))
                    Text("\(((contratosAbiertos.cantidadInvertida * contratosAbiertos.TIN) / 100), specifier: "%.02f€")").font(.system(size: 12)).bold()
                }
                Spacer()
                VStack{
                    Text("Periodo de cobro").font(.system(size: 10))
                    Text(contratosAbiertos.frecuenciaInteres.uppercased()).font(.system(size: 12)).bold()
                }
                Spacer()
                VStack{
                    Text("% TIN ").font(.system(size: 10))
                    Text("\(contratosAbiertos.TIN, specifier: "%.01f")%").font(.system(size: 12)).bold()
                }
                Spacer()
            }
            .padding().foregroundColor(.black).background(RoundedRectangle(cornerRadius: 10).fill(Color("ColorFondoGris")))
            
            .task {
                    datosFirebase.getDatosContratos()
            }
            
            if contratosAbiertos.estadoOperacion == "Pendiente" {
                NavigationLink(destination: Pago(contratosAbiertos: contratosAbiertos), isActive: $isActivoPago) {
                    Button {
                        verificacionDePago()
                        print("Pago")
                    } label: {
                        Spacer()
                        Text("REALIZAR TRANSFERENCIA").padding(4).foregroundColor(.black)
                        Spacer()
                    }
                }.padding(.horizontal, 20).background(Color("ColorLlamativo").cornerRadius(6))
                
            }
           
        }
                
            }
    func verificacionDePago() {
        DispatchQueue.main.async {
            self.isActivoPago = true
        }
    }
    }

