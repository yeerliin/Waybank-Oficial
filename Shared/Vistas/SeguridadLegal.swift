//
//  SeguridadLegal.swift
//  Waybank
//
//  Created by yerlin on 4/4/22.
//

import SwiftUI
import Firebase

struct SeguridadLegal: View {
    @ObservedObject var datosFirebase = FirebaseViewModel()
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var icono = "circle.fill"
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading){
                HStack {
                    Spacer()
                    Text("SEGURIDAD Y GARANTÍAS").foregroundColor(.blue).font(.system(size: 16, weight: .heavy, design: .default))
                    Spacer()
                }.padding(.vertical, 4)
                    TituloSeguridad(icono: "house.fill", texto: "Garantías")
                    TextoGarantias()
                
        VStack{
           ForEach(datosFirebase.datosFaq){ datos in
               Label(datos.title, systemImage: icono).padding(.vertical, 4).font(.system(size: 12, weight: .heavy, design: .default))
                Text("\(datos.description)").font(.system(size: 10)).multilineTextAlignment(.leading)
                
            }
        }
            }.padding().foregroundColor(.black).background(Color.white.cornerRadius(8))            }.padding(8).edgesIgnoringSafeArea(.bottom)
        }.navigationBarItems(trailing: logowaybank())
            .navigationBarTitleDisplayMode(.inline)
            .task {
            datosFirebase.getDatosFaq()
        }
        
       
    }
}

struct TituloSeguridad: View {
    var icono = "house.fill"
    var texto = "titulo"
    var body: some View {
        Label(texto, systemImage: icono).padding(.vertical, 4).font(.system(size: 12, weight: .heavy, design: .default))
    }
}

struct TextoGarantias: View {
    var body: some View {
        Text("JBH Financial Group S.L con CIF B06770143 - Registro Mercantil Central: T.3329, F.136, H.GI69865 - Passeig Mestrança 90/91 17300 Blanes (GI) España. Teléfono: +34 972354774 \n\nWayBank es reprentada legalmente en España por JBH Financial Group SL \n\nCapital Social 100.000,00€ \nVolumen de negocio: 25M €/año. \n\nEntidad registrada en Eurosistema del Banco de España con el Código Europeo: ES6718 \nLa copañia es auditada contablemente por ETL GLOBAL NEXUM https://www.elegalnexum.com \n\nWayBank y JBH Financial Group S.L. se encuentran protegidas por un Seguro de Responsabilidad Civil Profesional tal como exige el Real Decreto 84/2015 de 13 de febrero, por el que se desarrolla la Ley 10/2014 de 26 de junio, de ordenación, supervision y solvencia de entidades de crédito y en Real Decreto 217/2008 de 15 de febrero, sobre el régimen jurídico de las empresas de servicios de inversión, o legislción posterior qe l regule \n\nCompañia de Seguro: AXA SEGUROS GENERALES, S.A \nPóliza: 82453571 \nResponsabilidad Civil Profesional: 2.400.000,00€ ").font(.system(size: 10)).multilineTextAlignment(.leading)
    }
}

struct TextoWaybankSeguro: View {
    var body: some View {
        Text("Waybank es seguro porque usa la tecnología Blockchain de Ethereum para crear los contratos NTFs. Una vez grabados nadie puede alterarlos. Un SMARTCONTRACT es un tipo especial de instrucciones que es almacenada en la blockchain. Y que además tiene la capacidad de autoejecutar acciones de acuerdo a una serie de parámetros ya programado. Todo esto de forma inmutable, transparente y completamente segura.").font(.system(size: 10)).multilineTextAlignment(.leading)
    }
}
struct TextoPerderDinero: View {
    var body: some View {
        Text("No. Una vez grabado el contrato en la Blockchain, tanto el capital como el rendimiento quedan garantizados, siendo imposible alterar las condiciones, plazos, importes o cualquier otro parámetro.").font(.system(size: 10)).multilineTextAlignment(.leading)
    }
}

struct SeguridadLegal_Previews: PreviewProvider {
    static var previews: some View {
        SeguridadLegal()
    }
}
