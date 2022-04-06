//
//  EstructuraGlobal.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import SwiftUI
import Firebase

struct EstructuraViewModel: View {
    @State var test = ""
    var body: some View {
        WaybankLogoGrande()
            
    }
}



//Estructura de modificacion general
struct BotonBaseStyle : ViewModifier {
    //Podemos crear variables para cambiar "X" Colores, medidas, etc.. para hacer la personalizacion mas unica.
    var color : Color
    func body(content: Content) -> some View {
        content
            //Aqui añadimos la personalizacion del boton y luego lo añadimos  al final del boton y colocamos .modifier(BotonBaseStyle(color: .red))
            .font(.body)
            .frame(width: 100, height: 15, alignment: .center)
            .foregroundColor(.white)
            .padding(8)
            .background(color.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .cornerRadius(10.0)
            .shadow(radius: 4.0, x: 10, y: 10)
    }
}

struct CustomPlaceholder<T: View>: ViewModifier {
    var placeholder: T
    var show: Bool
    var color : Color
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if show {
                placeholder
                    //Moficamos todos los placeholder
                    .padding(8)
                    .frame(width: 250, height: 30, alignment: .leading)
                    .background(color)
                    .foregroundColor(.black)
                    .font(.headline)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .cornerRadius(10.0)
                    .padding(.horizontal, 8)
            }
            content
        }
    }
}
// Para modificar el placeholder  .placeholder(Text("Hola").bold(), show: test.isEmpty)
extension View {
    func placeholder<T: View>(_ view: T, show: Bool, color: Color) -> some View {
        self
            .modifier(CustomPlaceholder(placeholder: view, show: show, color: color))
            
    }
}

struct TextFieldBase : ViewModifier {
    //Podemos crear variables para cambiar "X" Colores, medidas, etc.. para hacer la personalizacion mas unica.
    var color : Color
    func body(content: Content) -> some View {
        content
            //Aqui añadimos la personalizacion del boton y luego lo añadimos  al final del boton y colocamos .modifier(BotonBaseStyle(color: .red))
            .padding(8)
            .frame(width: 300, height: 30, alignment: .center)
            .foregroundColor(.black)
            .font(.headline)
            .disableAutocorrection(true)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background(color)
            .cornerRadius(10.0)
            .shadow(radius: 10.0, x: 20, y: 10)
            .padding(.horizontal, 8)
            
    }
}

struct WaybankLogoGrande: View {
    var body: some View {
        Image("WaybankTextoLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 250)
            .cornerRadius(10.0)
            .shadow(radius: 5.0, x: 10, y: 10)
    }
}

extension Double {
    func redondear(numeroDeDecimales: Double) -> String {
        let formateador = NumberFormatter()
        formateador.maximumFractionDigits = Int(numeroDeDecimales)
        formateador.roundingMode = .down
        return formateador.string(from: NSNumber(value: self)) ?? ""
    }
}


extension String {
    func currencyFormatting() -> String {
    if let value = Double(self) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        if let str = formatter.string(for: value) {
            return str
        }
    }
        return ""
    }
}
//TESTEO
//Boton para cerrar sesion
struct botonCerrarSesion: View {
    @AppStorage("log_status") var log_Status = false
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var loginShow : FirebaseViewModel
    var body: some View {
        Button(action: {
            try! Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "sesion")
            loginShow.showLogin = false
            viewModel.signOut()
            log_Status = false
        }, label: {
            Text("Cerrar Sesion")
                
        }).cornerRadius(10.0)
        .shadow(radius: 10.0, x: 20, y: 10)
    }
}

struct logowaybank: View {
    var body: some View {
        Image("WaybankTextoLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100)
    }
}
