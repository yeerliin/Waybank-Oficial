//
//  Simulador.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//


import SwiftUI

struct Simulador: View {
    
    @ObservedObject var datosFirebase = FirebaseViewModel()
    @ObservedObject var frequenciaDuracion = SimuladorViewModel()
    
    @State var frequenciaEnum : FrequenciaDePago
    @State var capital = ""
    @State var periodoDePagos = "Trimestral"
    @State var moneda = "€"
    @State var activoUnAño = false
    @State var activoDosAños = true
    @State var activoTresAños = false
    
    @State var aceptoReinversion = false
    @State var resultado = 0
    
    var body: some View {
        
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            ScrollView{
                IdReseller(datosFirebase: datosFirebase)
                VStack(alignment: .leading){
                    Text("Nuevo Contrato").bold().font(.system(size: 18)).foregroundColor(.black)
                    Text("Capital Inicial").font(.system(size: 14)).foregroundColor(.black)
                    HStack{
                        TextField("Minimo \(datosFirebase.inversionMinima.inversionMinima, specifier: "%.2f") €", text: $capital)
                            .textFieldStyle(.roundedBorder).keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .contentShape(Rectangle())
                            .colorScheme(.light)
                        
                        Image(systemName: "xmark.circle")
                            .foregroundColor(Color("ColorCerrado"))
                            .onTapGesture {
                                self.capital = ""
                            }
                    }.contentShape(Rectangle())
                    Text("Duración del rendimiento").font(.system(size: 14)).foregroundColor(.black)
                    BotoneDeAños(frequenciaDuracion: frequenciaDuracion, activoUnAño: $activoUnAño, activoDosAños: $activoDosAños, activoTresAños: $activoTresAños)
                    Text("Disponibilidad del rendimiento").font(.system(size: 14)).foregroundColor(.black)
                    TituloTabla()
                    if capital.isEmpty {
                        TablaSinDatos(frequenciaDuracion: frequenciaDuracion)
                        Text("Reinversión").font(.system(size: 14)).foregroundColor(.black)
                        VStack {
                            HStack {
                                Text("Quiero reinvertir mis ganancias").bold().font(.system(size: 14)).foregroundColor(.black)
                                Button {
                                    self.aceptoReinversion.toggle()
                                } label: {
                                    Image(systemName: aceptoReinversion ? "checkmark.square.fill" : "square").foregroundColor(.black)
                                }
                                Spacer()
                            }
                            Spacer()
                         }
                    }else{
                        TablaDeDatos(frequenciaDuracion: frequenciaDuracion, datosFirebase: datosFirebase, capital: capital)
                        Text("Reinversión").font(.system(size: 14)).foregroundColor(.black)
                        HStack {
                            Text("Quiero reinvertir mis ganancias").bold().font(.system(size: 14)).foregroundColor(.black)
                            Button {
                                self.aceptoReinversion.toggle()
                            } label: {
                                Image(systemName: aceptoReinversion ? "checkmark.square.fill" : "square").foregroundColor(.black)
                            }
                        }
                        ResumenDelContrato(frequenciaDuracion: frequenciaDuracion, capital: capital, botonReinversion: $aceptoReinversion)
                        DetalleSimulador(frequenciaDuracion: frequenciaDuracion, capital: capital)
                    }
                    //Dentro del Scroll
                }   .padding(.horizontal)
                    .navigationBarItems(trailing: logowaybank())
                    .navigationBarTitleDisplayMode(.inline)
                
            }
            .task {
                datosFirebase.getIntereses()
                datosFirebase.getDatosUsuario()
                
            }
        }
        
    }
} // Vista Principal

struct TituloTabla : View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Text("Frequencia").bold().font(.system(size: 14))
                    .frame(width: geometry.size.width / 4, alignment: .leading)
                Text("% TIN").bold().frame( alignment: .center).font(.system(size: 14))
                    .frame(width: geometry.size.width / 4)
                Text("Rendimiento").bold().font(.system(size: 14))
                    .frame(width: geometry.size.width / 4, alignment: .center)
                Text("Total").bold().font(.system(size: 14))
                    .frame(width: geometry.size.width / 4)
                
            }
        }
        
    }
}

struct BotoneDeAños: View {
    var frequenciaDuracion : SimuladorViewModel
    @Binding var activoUnAño : Bool
    @Binding var activoDosAños : Bool
    @Binding var activoTresAños : Bool
  var body: some View {
        HStack {
            Button {
                frequenciaDuracion.tablaSimulador(duracion: 12, frequencia: frequenciaDuracion.frequenciaDePagos)
                frequenciaDuracion.getDuracion(duracion: .unAño)
                activoUnAño = true
                activoDosAños = false
                activoTresAños  = false
            } label: {
                Text("12 MESES").bold().padding().background(activoUnAño ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(8)
                    .shadow(radius: 8)
            }
            Button {
                frequenciaDuracion.tablaSimulador(duracion: 24, frequencia: frequenciaDuracion.frequenciaDePagos)
                frequenciaDuracion.getDuracion(duracion: .dosAños)
                activoUnAño = false
                activoDosAños = true
                activoTresAños  = false
            } label: {
                Text("24 MESES").bold().padding().background(activoDosAños ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(8)
                    .shadow(radius: 8)
            }
            Button {
                frequenciaDuracion.tablaSimulador(duracion: 36, frequencia: frequenciaDuracion.frequenciaDePagos)
                frequenciaDuracion.getDuracion(duracion: .tresAños)
                activoUnAño = false
                activoDosAños = false
                activoTresAños  = true
            } label: {
                Text("36 MESES").bold().padding().background(activoTresAños ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(8)
                    .shadow(radius: 8)
            }
        }.padding(.all, -1.0).foregroundColor(.white).font(.system(size: 16))
    }
}

struct TablaSinDatos :View {
   @StateObject var frequenciaDuracion : SimuladorViewModel
    
    var body: some View {
        VStack(spacing: 4){
            Button {
                frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 12)
                frequenciaDuracion.getFrequencia(frequencia: .mensual)
                
            } label: {
                GeometryReader { geometry in
                    HStack{
                        Text("Mensual")
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }.padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .padding(.bottom, 2)
            }   .background(frequenciaDuracion.botonSeleccionat == "Mensual" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                .foregroundColor(Color.white)
            
            Button {
                frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 4)
                frequenciaDuracion.getFrequencia(frequencia: .trimestral)
            } label: {
                GeometryReader { geometry in
                    HStack{
                        Text("Trimestral")
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }.padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .padding(.bottom, 2)
            }   .background(frequenciaDuracion.botonSeleccionat == "Trimestral" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                .foregroundColor(Color.white)
            
            
            Button {
                frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 2)
                frequenciaDuracion.getFrequencia(frequencia: .semestral)
                
            } label: {
                GeometryReader { geometry in
                    HStack{
                        Text("Semestral")
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }.padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .padding(.bottom, 2)
            }   .background(frequenciaDuracion.botonSeleccionat == "Semestral" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                .foregroundColor(Color.white)
            
            Button {
                frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 1)
                frequenciaDuracion.getFrequencia(frequencia: .anual)
                
            } label: {
                GeometryReader { geometry in
                    HStack{
                        Text("Anual")
                        Spacer()
                    }.frame(maxWidth: .infinity)
                }.padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .padding(.bottom, 2)
            }   .background(frequenciaDuracion.botonSeleccionat == "Anual" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                .foregroundColor(Color.white)
            
        }
        .font(.system(size: 12))
        .task {
            frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: frequenciaDuracion.frequenciaDePagos)
            
        }
    }
}

struct RetornoSimulacionTotal: View {
    
   
    var porcentaje = ""
    var fechaPlus : Int = 0
    var fecha = Date()
    var capital = 0.0
    var body: some View {
      
        
        VStack(spacing: 4){
      
            HStack{
                Text("Fecha liquidacion").font(.system(size: 10))
                Spacer()
                Text("Rendimiento").font(.system(size: 10))
                
            }
            HStack{
                Text("\((fecha).addYear(n: fechaPlus).formatDate())").font(.system(size: 10)).bold()
                     Spacer()
                Text("\(capital, specifier: "%.2f€")").font(.system(size: 10)).bold()
                
            }
            
            
        }.padding().background(RoundedRectangle(cornerRadius: 20).fill(Color("ColorFondoTabla"))).foregroundColor(.black).shadow(radius: 4)
        }

}

struct TablaDeDatos: View {
    @ObservedObject var frequenciaDuracion : SimuladorViewModel
    @StateObject var datosFirebase = FirebaseViewModel()
    var capital : String
    var body: some View {
        
        VStack(spacing: 4){
                    let resultadoRendimientoMes = Double(capital)!  * Double(frequenciaDuracion.interesMensual) / 100
                    let resultadoRendimientoTri = Double(capital)! * Double(frequenciaDuracion.interesTrimestral) / 100
                    let resultadoRendimientoSem = Double(capital)! * Double(frequenciaDuracion.interesSemestral) / 100
                    let resultadoRendimientoAnual = Double(capital)! * Double(frequenciaDuracion.interesAnual) / 100
           
                Button {
                    frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 12)
                    frequenciaDuracion.getFrequencia(frequencia: .mensual)
                } label: {
                    GeometryReader { geometry in
                        HStack(spacing: 0){
                            Text("Mensual").frame(width: geometry.size.width / 4, alignment: .leading)
                            Text("\(Double(frequenciaDuracion.interesMensual), specifier: "%.1f")").frame(width: geometry.size.width / 4)
                            Text("\(Double(resultadoRendimientoMes), specifier: "%.2f")€" ).frame(width: geometry.size.width / 4, alignment: .center)
                            Text("\(Double(Double(capital)! + Double(resultadoRendimientoMes)), specifier: "%.2f")€").frame(width: geometry.size.width / 4, alignment: .trailing)
                        }.frame(maxWidth: .infinity)
                    }   .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .padding(.bottom, 2)
                }
                    .background(frequenciaDuracion.botonSeleccionat == "Mensual" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                    .foregroundColor(Color.white)
                
                Button {
                    frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 4)
                    frequenciaDuracion.getFrequencia(frequencia: .trimestral)
                    
                 } label: {
                     GeometryReader { geometry in
                         HStack(spacing: 0){
                            Text("Trimestral").frame(width: geometry.size.width / 4, alignment: .leading)
                            Text("\(Double(frequenciaDuracion.interesTrimestral), specifier: "%.1f")").frame(width: geometry.size.width / 4)
                             Text("\(Double(resultadoRendimientoTri), specifier: "%.2f")€" ).frame(width: geometry.size.width / 4, alignment: .center)
                            Text("\(Double(Double(capital)! + Double(resultadoRendimientoTri)), specifier: "%.2f")€").frame(width: geometry.size.width / 4, alignment: .trailing)
                         }.frame(maxWidth: .infinity)
                     }  .padding(.horizontal, 8)
                         .padding(.vertical, 4)
                         .padding(.bottom, 2)
                }
                    .background(frequenciaDuracion.botonSeleccionat == "Trimestral" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                    
                    .foregroundColor(Color.white)
                
                Button {
                    frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 2)
                    frequenciaDuracion.getFrequencia(frequencia: .semestral)
                   
                    
                } label: {
                    GeometryReader { geometry in
                        HStack(spacing: 0){
                            Text("Semestral").frame(width: geometry.size.width / 4, alignment: .leading)
                            Text("\(Double(frequenciaDuracion.interesSemestral), specifier: "%.1f")").frame(width: geometry.size.width / 4)
                            Text("\(Double(resultadoRendimientoSem), specifier: "%.2f")€" ).frame(width: geometry.size.width / 4, alignment: .center)
                            Text("\(Double(Double(capital)! + Double(resultadoRendimientoSem)), specifier: "%.2f")€").frame(width: geometry.size.width / 4, alignment: .trailing)
                        }.frame(maxWidth: .infinity)
                    }.padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .padding(.bottom, 2)
                    
                 }.background(frequenciaDuracion.botonSeleccionat == "Semestral" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                    
                    .foregroundColor(Color.white)
                
                Button {
                    frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: 1)
                    frequenciaDuracion.getFrequencia(frequencia: .anual)
                } label: {
                    GeometryReader { geometry in
                        HStack(spacing: 0){
                            Text("Anual").frame(width: geometry.size.width / 4, alignment: .leading)
                            Text("\(Double(frequenciaDuracion.interesAnual), specifier: "%.1f")").frame(width: geometry.size.width / 4)
                            Text("\(Double(resultadoRendimientoAnual), specifier: "%.2f")€" ).frame(width: geometry.size.width / 4,alignment: .center)
                            Text("\(Double(Double(capital)! + Double(resultadoRendimientoAnual)), specifier: "%.2f")€").frame(width: geometry.size.width / 4, alignment: .trailing)
                        }.frame(maxWidth: .infinity)
                    }.padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .padding(.bottom, 2)
                    
                }
                    .background(frequenciaDuracion.botonSeleccionat == "Anual" ? Color("ColorTerciario")  : Color("ColorPrincipal")).cornerRadius(4)
                    
                    .foregroundColor(Color.white)
             }.font(.system(size: 12))
            .task {
                frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: frequenciaDuracion.frequenciaDePagos)
        }
        
    }
}

struct ResumenDelContrato: View {
    
    enum ActiveAlert {
        case primero, segundo
    }
    
    @ObservedObject var frequenciaDuracion : SimuladorViewModel
    @StateObject var simulacionContrato = FirebaseViewModel()
    var capital : String
    @State private var showAlerta = false
    @State private var activeAlert : ActiveAlert  = .primero
    @Binding var botonReinversion : Bool
    var body: some View {
        
        VStack {
            let resultadoRendimiento = Double(capital)! * Double(frequenciaDuracion.interesResumenTin) / 100
            HStack {
                Text("RESUMEN CONTRATO").bold().font(.system(size: 15)).foregroundColor(.black).padding(.top, 4)
                Spacer()
            }
            VStack {
               HStack{
                    VStack(alignment: .leading){
                        Text("\(Double(capital)!, specifier: "%.2f")€").bold().font(.system(size: 15))
                        Text("Capital inicial")
                        Text("Fecha").bold().font(.system(size: 15))
                        Text("Fecha vencimiento")
                        Text("Frequencia").bold().font(.system(size: 15))
                        Text("Frecuencia de disponibilidad")
                    }
                    Spacer()
                    VStack(alignment: .trailing){
                        Text("\(resultadoRendimiento, specifier: "%.2f")€ ").bold().font(.system(size: 15))
                        Text("Rendimiento")
                        Text("\(Double(frequenciaDuracion.interesResumenTae), specifier: "%.1f")").bold().font(.system(size: 15))
                        Text("% T.A.E")
                        if botonReinversion == false {
                            Text("No").font(.system(size: 15))
                        }else{
                            Text("Si").font(.system(size: 15))
                        }
                        Text("Reinversion")
                    }
                    
                }
                
                HStack{
                    Button {
                        if Double(capital)! < simulacionContrato.inversionMinima.inversionMinima {
                            self.activeAlert = .primero
                            print(showAlerta)
                        }else{
                            self.activeAlert = .segundo
                            print(showAlerta)
                         }
                            self.showAlerta = true
                     } label: {
                        Text("CONTRATAR").bold().frame(maxWidth: .infinity).padding().background(Color("ColorPrincipal")).cornerRadius(8)
                            .shadow(radius: 8).foregroundColor(.white).font(.system(size:18))
                    }
                    .alert(isPresented: $showAlerta)  {
                        switch activeAlert {
                            case .segundo:
                                return Alert(title: Text("ALTA CONTRATO"), message: Text("¿Deseas confirmar el alta de este contrato?"), primaryButton: .destructive(Text("CANCELAR"), action: {
                                    print("cancelando")
                                }),secondaryButton: .default(Text("ACEPTAR"), action: {
                                  simulacionContrato.creacionContrato(TIN: frequenciaDuracion.interesResumenTin, cantidadInvertida: Double(capital)!, comisionReseller: 0.0, estadoOperacion: "Pendiente", fechaMovimiento: Date(), frecuenciaInteres: "\(frequenciaDuracion.botonSeleccionat)", idContrato: "\(Date().timeIntervalSince1970.rounded().cleanValue)", interes: frequenciaDuracion.interesResumenTae, periodoInversion: frequenciaDuracion.añosDeDuracion , reinvertir: botonReinversion, smartContract: ""){ done in
                                        if done {
                                            print("Contrato Pendiente")
                                        }
                                    }
                                }
                                                            ))
                            case .primero:
                                return Alert(title: Text("CAPITAL MÍNIMO"), message: Text("Ha solicitado una inversíon de \(capital)€, el importe minimo es de \(simulacionContrato.inversionMinima.inversionMinima, specifier: "%.0f")€"), dismissButton: .default(Text("Aceptar"), action: {
                                    
                                }))
                        }
                        
                    }
                    
                     Button {
                        //TODO
                    } label: {
                        Text("VOLVER").bold().frame(maxWidth: 75).padding().background(Color("ColorCerrado")).cornerRadius(8)
                            .shadow(radius: 8).foregroundColor(.white).font(.system(size:18))
                    }
                }.padding(.top)
            }.frame(maxWidth: .infinity).padding().background(RoundedRectangle(cornerRadius: 10).fill(Color(.white))).font(.system(size:12)).shadow(radius: 8).foregroundColor(.black)
        }.task {
            frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: frequenciaDuracion.frequenciaDePagos)
            simulacionContrato.getIntereses()
       }
    }
}

struct DetalleSimulador : View {
    @ObservedObject var frequenciaDuracion : SimuladorViewModel
    var capital : String
    
    var body: some View {
        VStack(alignment: .center){
            VStack {
                Text("DETALLE RENDIMIENTO Y RETORNO INVERSIÓN").bold().font(.system(size: 12))
                Text("Fechas en las que se te ingresarás los intereses de tu inversíon.").font(.system(size: 10))
            }.padding(.vertical,4)
            
            ForEach(1...frequenciaDuracion.pagosRealizar, id: \.self) {
               
                RetornoSimulador(frequenciaDuracion: frequenciaDuracion, capital: capital, porcentaje: String(frequenciaDuracion.interesResumenTin), fechaPlus: $0 * frequenciaDuracion.pagosFecha , fecha: Date())
                Divider().foregroundColor(Color.black)
            }
            RetornoSimulacionTotal(porcentaje: String(frequenciaDuracion.interesResumenTin), fechaPlus: frequenciaDuracion.añosIntDuracion, fecha: Date(), capital: Double(capital) ?? 0)
            
            
        }.task {
            frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: frequenciaDuracion.frequenciaDePagos)
        }
    }
}

struct RetornoSimulador: View {
    @ObservedObject var frequenciaDuracion : SimuladorViewModel
    var capital : String
    var porcentaje = ""
    var fechaPlus : Int = 0
    var fecha = Date()
    
    var body: some View {
        VStack{
            let resultadoRendimiento = Double(capital)! * Double(porcentaje)! / 100
            VStack(spacing: 4){
            
                HStack{
                    Text("Fecha liquidacion").font(.system(size: 10))
                    Spacer()
                    Text("Rendimiento").font(.system(size: 10))
                }
                HStack{
                    Text("\((fecha).addMonth(n: fechaPlus).formatDate())").font(.system(size: 10)).bold()
                    Spacer()
                    Text("\(( Double(resultadoRendimiento) / Double(frequenciaDuracion.pagosRealizar)),specifier: "%.2f€")").font(.system(size: 10)).bold()
                }
             }.padding()
        }.background(RoundedRectangle(cornerRadius: 20).fill( Color("ColorFondoTabla"))).foregroundColor(.black).shadow(radius: 4)
            .task {
               frequenciaDuracion.tablaSimulador(duracion: frequenciaDuracion.añosDeDuracion, frequencia: frequenciaDuracion.frequenciaDePagos)
           }
    }
}
