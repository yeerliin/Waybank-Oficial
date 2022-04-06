//
//  Pago.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import SwiftUI

struct Pago: View {
    @ObservedObject var datosFirebase = FirebaseViewModel()
    let contratosAbiertos : DatosContratosWaybank
    @State var alertConfirmacion = false
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            
                
            VStack {
                ScrollView {
                                PaginaDePagos(contratosAbiertos: contratosAbiertos)
                       
                        
                }.edgesIgnoringSafeArea(.bottom)
                Button {
                    alertConfirmacion = true
                    print("Enviar Correo")
                } label: {
                    Text("ENVIAR CONFIRMACIÓN DE PAGO").foregroundColor(.black).padding()
                }.frame(maxWidth: .infinity).background(Color.yellow.cornerRadius(6)).padding()
                    .alert(isPresented: $alertConfirmacion)  {
                        Alert(title: Text("¿Ha realizado la transferencia?"), message: Text("En un maximo de 5 dias habiles se le activara su contrato, para cualquier duda contacte con soporte"), primaryButton: .destructive(Text("No"), action: {
                            print("cancelando")
                        }),secondaryButton: .default(Text("SI"), action: {
                            print("aceptar")
                        }))
                    }
            }
                
            
            }
            .navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Text("Monedero Fiat (SEPA)"))
    }
}

/*
struct Pago_Previews: PreviewProvider {
    static var previews: some View {
        Pago()
    }
}*/



struct PaginaDePagos: View {
    var contratosAbiertos : DatosContratosWaybank
    var body: some View {
        
            VStack{
                
                VStack(alignment: .leading){
                    
                    Group {
                        
                        Text("Utilice la siguiente información para transferir fondos en EUR o USD a su cuenta de WayBank.net").padding(.bottom, 6).font(.system(size: 15))
                        HStack{
                            Image(systemName: "house.fill")
                            Text("Compra criptomonedas con tu saldo al instante.").padding(.vertical, 4)
                        }
                        HStack{
                            Image(systemName: "house.fill")
                            Text("Transfiera de 100 a 1 millón de EUR o USD de una sola vez.").padding(.vertical, 4)
                        }
                        
                    }
                    Group {
                        Text("IBAN").padding(.bottom, -4)
                        HStack {
                            Text("ES34 2100 3714 2122 0037 3181").padding(.vertical, 6).padding(.horizontal, 8)
                            Spacer()
                        }.background(.white)
                        Text("SWIFT").padding(.bottom, -4)
                        HStack {
                            Text("CAIX ES BB XXX").padding(.vertical, 6).padding(.horizontal, 8)
                            Spacer()
                        }.background(.white)
                        
                        Text("NOMBRE DEL TITULAR DE LA CUENTA").padding(.bottom, -4)
                        HStack {
                            Text("JBH Financial Group SL").padding(.vertical, 6).padding(.horizontal, 8)
                            Spacer()
                        }.background(.white)
                        
                        Text("NOMBRE DEL BANCO").padding(.bottom, -4)
                        Group {
                            HStack {
                                Text("CAIXABANK").padding(.vertical, 6).padding(.horizontal, 8)
                                Spacer()
                            }.background(.white)
                            Text("DIRECCIÓN DEL BANCO").padding(.bottom, -4)
                            HStack {
                                Text("Rambla de Joaquim Ruyra, 65, 17300 Blanes, Girona").padding(.vertical, 6).padding(.horizontal, 8)
                                Spacer()
                            }.background(.white)
                            Text("PAÍS DEL BANCO").padding(.bottom, -4)
                            HStack {
                                Text("ESPAÑA").padding(.vertical, 6).padding(.horizontal, 8)
                                Spacer()
                            }.background(.white)
                            
                            Text("Capital inicial").padding(.bottom, -4)
                            
                                HStack {
                                    Text("\(contratosAbiertos.cantidadInvertida)").padding(.vertical, 6).padding(.horizontal, 8)
                                    Spacer()
                                }.background(.white)
                            
                          
                            Text("Descripción").padding(.bottom, -4)
                            HStack {
                                Text("ID: \(contratosAbiertos.idContrato)").padding(.vertical, 6).padding(.horizontal, 8)
                                Spacer()
                            }.background(.white)
                            Text("El nombre de su cuenta bancaria debe coincidir con el nombre legal asociado con su cuenta Waybank.net. La transferencia puede tardar entre 2 y 5 días hábiles en estar disponible en la aplicación. El depósito no se puede reembolsar ni devolver a la cuenta de fondos. Waybank no cambia tarifas por transferencia bancaria, pero su banco podría hacerlo, consulte con ellos en consecuencia. Utilice su cuenta bancaria personal para depositar directamente, es posible que no se admitan retiros fiduciarios a proveedores de pago de terceros.").font(.system(size: 8)).padding(.top, 4)
                        }
                    }
                    
                }.padding().foregroundColor(.black).font(.system(size: 12))
                
            }
           
       
        
    }
}
