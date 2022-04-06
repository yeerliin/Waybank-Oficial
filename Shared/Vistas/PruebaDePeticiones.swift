//
//  PruebaDePeticiones.swift
//  Waybank
//
//  Created by yerlin on 3/4/22.
//

import SwiftUI


import SwiftUI
import Firebase

struct PruebasDePeticiones: View {
    @ObservedObject var datosFirebase = FirebaseViewModel()
    var vistaContrato: DatosContratosWaybank
    @State var sumaCapital = 0.0
    @State var sumaRendimiento = 0.0
    @State var sumaTotal = 0.0
    @State var isActivoPago = false
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            VStack{
                IdReseller(datosFirebase: datosFirebase).padding(.bottom, 2).padding(.top, -6)
                Spacer()
                HStack(alignment: .bottom){
                    VStack(alignment: .leading) {
                        Text("RESUMEN CONTRATO").font(.system(size: 14)).bold().foregroundColor(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        HStack {
                            Text("Estado Contrato:").font(.system(size: 12)).foregroundColor(.white)
                            if vistaContrato.estadoOperacion == "Activo" {
                                Text(vistaContrato.estadoOperacion.uppercased()).font(.system(size: 12)).bold().foregroundColor(Color("ColorActivo"))
                            } else if vistaContrato.estadoOperacion == "Pendiente" {
                                Text(vistaContrato.estadoOperacion.uppercased()).font(.system(size: 12)).bold().foregroundColor(Color("ColorPendiente"))
                            } else {
                                Text(vistaContrato.estadoOperacion).font(.system(size: 12)).bold().foregroundColor(Color("ColorCerrado"))
                            }
                        }
                        Text("Nº: \(vistaContrato.idContrato)".uppercased()).font(.system(size: 12)).bold().foregroundColor(.white)
                    }
                }
                VStack{
                    VStack(spacing: 4){
                        HStack{
                            Text("\((vistaContrato.cantidadInvertida), specifier: "%.2f€")").bold()
                            Spacer()
                            Text("\(((vistaContrato.cantidadInvertida * vistaContrato.TIN) / 100), specifier: "%.2f€")").bold()
                        }.font(.system(size: 14))
                        HStack{
                            Text("Capital inicial")
                            Spacer()
                            Text("Rendimiento T.I.N")
                        }.font(.system(size: 10))
                        HStack{
                            switch vistaContrato.periodoInversion {
                            case 12:
                                Text("\((vistaContrato.fechaMovimiento).addYear(n: 1).formatDate())").bold()
                            case 24:
                                Text("\((vistaContrato.fechaMovimiento).addYear(n: 2).formatDate())").bold()
                            case 36:
                                Text("\((vistaContrato.fechaMovimiento).addYear(n: 3).formatDate())").bold()
                            default:
                                Text("Error al cargar").bold()
                            }
                            
                            Spacer()
                            HStack {
                                Text("\((vistaContrato.TIN), specifier: "%.1f")%").bold()
                                Text("\((vistaContrato.interes), specifier: "%.1f")%").bold()
                            }
                        }.font(.system(size: 14))
                        HStack{
                            Text("Fecha vencimiento")
                            Spacer()
                            HStack {
                                Text("% TIN")
                                Text("% T.A.E.")
                            }
                        }.font(.system(size: 10))
                        HStack{
                            Text("\(vistaContrato.frecuenciaInteres)").bold()
                            Spacer()
                            if vistaContrato.reinvertir == true {
                                Text("SI").bold()
                            }else{
                                Text("NO").bold()
                            }
                            
                        }.font(.system(size: 14))
                        HStack{
                            Text("Frecuencia de disponibilidad")
                            Spacer()
                            Text("Reinversión")
                        }.font(.system(size: 10))
                        VStack {
                            
                            HStack(alignment: .center, spacing: 0) {
                                VStack{
                                    
                                }.frame(maxWidth: 100)
                                VStack {
                                    Text("\(datosFirebase.getSumaTotal(sumaTotal: sumaTotal), specifier: "%.2f") €").font(.system(size: 20)).bold()
                                    Text("SALDO TOTAL").font(.system(size: 12))
                                }.frame(maxWidth: .infinity)
                                
                                VStack{
                                    Group {
                                        if vistaContrato.estadoOperacion == "Activo" {
                                            NavigationLink(destination:
                                                            WebViewContratos(smartContracts: vistaContrato.smartContract)) {
                                                VStack{
                                                    Image(systemName: "newspaper.fill").resizable().frame(width: 15, height: 15, alignment: .center)
                                                    Text("SmartContract").font(.system(size: 12))
                                                }
                                            }.padding(.top, 2)
                                        } else {
                                            Button {
                                                datosFirebase.delete(idContrato: vistaContrato.idContrato, fechaDia: vistaContrato.fechaMovimiento.formatDia(), fechaMes: vistaContrato.fechaMovimiento.formatMes(), fechaAño: vistaContrato.fechaMovimiento.formatAño())
                                            } label: {
                                                VStack{
                                                    Image(systemName: "trash.fill").resizable().frame(width: 15, height: 15, alignment: .center)
                                                    Text("Borrar").font(.system(size: 12))
                                                }.padding(.top, 2)
                                            }
                                        }
                                    }
                                }.frame(maxWidth: 100, alignment: .trailing)
                                
                            }.frame(maxWidth: .infinity, alignment: .center).padding(.top, 13)
                        }
                       
                    }.padding()
                    
                }.background(RoundedRectangle(cornerRadius: 6).fill(Color.white)).foregroundColor(.black).shadow(radius: 4)
                if vistaContrato.estadoOperacion == "Pendiente" {
                    NavigationLink(destination: Pago(contratosAbiertos: vistaContrato), isActive: $isActivoPago) {
                        Button {
                            verificacionDePago()
                            print("Pago")
                        } label: {
                            Spacer()
                            Text("REALIZAR TRANSFERENCIA").bold().padding(4).foregroundColor(.black)
                            Spacer()
                        }
                    }.background(Color.yellow.cornerRadius(6))
                 }
                
                VStack(alignment: .center, spacing: 3, content: {
                    Text("DETALLE RENDIMIENTO Y RETORNO INVERSIÓN").font(.system(size: 12)).bold()
                    Text("Fechas en las que se te ingresaran los intereses de tu inversión.").font(.system(size: 10))
                }).padding(.vertical, 2).foregroundColor(.black)
                
               ScrollView{
                    ForEach(1...vistaContrato.frequenciaDePagoContratos, id: \.self) {
                        RetornoInversion(datoscontrato: vistaContrato, fechaPlus: $0 * vistaContrato.periodoInversionDeContratos)
                        Divider().foregroundColor(.black)
                    }
                   RetornoInversionTotal(datoscontrato: vistaContrato, fechaPlus: vistaContrato.añosDeDuracion)
                 }
                
            }.padding()
          }.edgesIgnoringSafeArea(.bottom)
            .task {
                datosFirebase.getDatosUsuario()
                datosFirebase.getDatosContratos()
            }
        
    }
    func verificacionDePago() {
        DispatchQueue.main.async {
            self.isActivoPago = true
        }
    }
}




struct RetornoInversion: View {
    
    var datoscontrato: DatosContratosWaybank
    var fechaPlus : Int = 0
    var body: some View {
      
        
            VStack{
                
                VStack(spacing: 4){
                    HStack{
                        Text("Fecha liquidacion").font(.system(size: 12))
                        Spacer()
                        Text("Rendimiento").font(.system(size: 12))
                        
                    }
                    
                    HStack{
                        
                        Text("\((datoscontrato.fechaMovimiento).addMonth(n: fechaPlus).formatDate())").font(.system(size: 12)).bold()
                        Spacer()
                        Text("\(((datoscontrato.cantidadInvertida)*(datoscontrato.TIN)/100),specifier: "%.2f€")").font(.system(size: 12)).bold()
                    }
                    
                }.padding()
                
                
            }.foregroundColor(.black).shadow(radius: 4).padding(.horizontal, 4)
            .navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
        }
            
    
    
}


struct RetornoInversionTotal: View {
    
    var datoscontrato: DatosContratosWaybank
    var fechaPlus : Int = 0
    var body: some View {
      
        
        VStack(spacing: 4){
      
            HStack{
                Text("Fecha liquidacion").font(.system(size: 10))
                Spacer()
                Text("Rendimiento").font(.system(size: 10))
                
            }
            HStack{
                Text("\((datoscontrato.fechaMovimiento).addYear(n: fechaPlus).formatDate())").font(.system(size: 10)).bold()
                     Spacer()
                Text("\((datoscontrato.cantidadInvertida),specifier: "%.2f€")").font(.system(size: 10)).bold()
            }
            
        }.padding().foregroundColor(.black).shadow(radius: 4)
        }

}


struct IdReseller: View {
    @ObservedObject var datosFirebase = FirebaseViewModel()
    var body: some View {
        VStack{
            Text((datosFirebase.datosDelUsuario.nombre!)  + " " + datosFirebase.datosDelUsuario.apellidos!).foregroundColor(Color("ColorFondoGris")).font(.system(size: 14))
            Button {
                UIPasteboard.general.string = "\((datosFirebase.datosDelUsuario.idCliente)!).\((datosFirebase.datosDelUsuario.idOficina)!).\((datosFirebase.datosDelUsuario.idReseller)!)"
                                       print(UIPasteboard.general.string!)
            } label: {
                Text("ID: \((datosFirebase.datosDelUsuario.idCliente)!).\((datosFirebase.datosDelUsuario.idOficina)!).\((datosFirebase.datosDelUsuario.idReseller)!)").font(.system(size: 10)).foregroundColor(Color("ColorFondoGris"))
                Image(systemName: "doc.on.doc").font(.system(size: 12)).foregroundColor(Color("ColorFondoGris"))
            }

        }.padding(.bottom, 10)
    }
}
