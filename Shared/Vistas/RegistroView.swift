//
//  RegistroView.swift
//  Waybank
//
//  Created by yerlin on 5/4/22.
//


import SwiftUI

struct RegistroView: View {
    
    //Registro
    @ObservedObject private var registroVM = RegistroModel()
    @StateObject var login = FirebaseViewModel()
    
    //Alertas
    @Environment(\.presentationMode) var presentatioMode
    @State private var showAlertCierre = false
    @EnvironmentObject var loginShow : FirebaseViewModel
    

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color("ColorPrincipal")]), startPoint: .bottom, endPoint: .top).edgesIgnoringSafeArea(.all)
            VStack {
                logowaybank()
                
                SingleFormView(fieldName: "", fieldValue: $registroVM.email)
                    .placeholder(Text("Correo Electronico"), show: registroVM.email.isEmpty, color: Color(.white))
                    .modifier(TextFieldBase(color: Color(.white)))
                    .padding(.vertical,6)
                    
                
                SingleFormView(fieldName: "", fieldValue: $registroVM.password, isProtected: true)
                    .placeholder(Text("Contraseña"), show: registroVM.password.isEmpty, color: Color(.white))
                    .modifier(TextFieldBase(color: Color(.white)))
                    VStack {
                        
                        ValidationFormView(
                            iconName: registroVM.passwordLengthValid ? "checkmark.circle" : "xmark.circle",
                            iconColor: registroVM.passwordLengthValid ? Color.green : Color.red,
                            formText: "Minimo 8 caracteres",
                            conditionChecked: registroVM.passwordLengthValid)
                        
                        ValidationFormView(
                            iconName: registroVM.passwordNumber ? "checkmark.circle" : "xmark.circle",
                            iconColor: registroVM.passwordNumber ? Color.green : Color.red,
                            formText: "Minimo digito",
                            conditionChecked: registroVM.passwordNumber)
                        
                        
                        ValidationFormView(
                            iconName: registroVM.passwordCapitalLetter ? "checkmark.circle" : "xmark.circle",
                            iconColor: registroVM.passwordCapitalLetter ? Color.green : Color.red,
                            formText: "Una mayuscula y una minuscula",
                            conditionChecked: registroVM.passwordCapitalLetter)
                    }.padding().padding(.horizontal)
                
                
                
                SingleFormView(fieldName: "", fieldValue: $registroVM.confirmPassword, isProtected: true)
                    .placeholder(Text("Confirmar contraseña"), show: registroVM.confirmPassword.isEmpty, color: Color(.white))
                    .modifier(TextFieldBase(color: Color(.white)))
                    ValidationFormView(
                        iconName: registroVM.passwordMatch ? "checkmark.circle" : "xmark.circle",
                        iconColor: registroVM.passwordMatch ? Color.green : Color.red,
                        formText: "Las dos contraseñas deben coincidir",
                        conditionChecked: registroVM.passwordMatch).padding()
                    .padding(.horizontal)
                
                
                Button(action: {
                    //Iniciar sesion
                    login.login(email: registroVM.email, password: registroVM.password) { (done) in
                            if done {
                                
                                login.crearUsuario(password: "", Apellidos: "", Banco: "", CP: "", Descripcion: "", DescripcionFondos: "", Direccion: "", DireccionBanco: "", DNI: "", email: "\(registroVM.email)", Estado: false, EstadoCivil: "", FechaAlta: Date(), FechaBaja: Date(), FechaNacimiento: "", Iban: "", iDCliente: 0, idOficina: 0, iDReseller: 0, Idioma: "ESP", Incremento: 0, iPAlta: "", iPUltima: "false", KYC: false, Moneda: "", Nombre: "", Pais: "", Poblacion: "", Profesion: "", Provider: "", Provincia: "", RangoInversionHasta: 0, RangoInversionDesde: 0, Riesgo: 0, Sexo: "", Swift: "", Telefono: "", Vip: false) { done in
                                    if done {
                                        UserDefaults.standard.set(true, forKey: "sesion")
                                        loginShow.showLogin.toggle()
                                    }else{
                                        print("Error de registro")
                                    }
                                    
                                }
                                
                            }
                    }
                    print("Registro Activo")
                }, label: {
                    Text("Registrarme")
                        .modifier(BotonBaseStyle(color: Color("ColorPrincipal")))
                }).padding()
                .hoverEffect(.lift)
                Spacer()
            }.padding() //Modificar el padding para que se vea bien al momento de abrir el modal.
            
        }.overlay(
            HStack{
                Spacer()
                VStack {
                    Button(action: {
                        //Para cerrar el modal directamente
                        self.presentatioMode.wrappedValue.dismiss()
                       
                        print("Activar alerta de cerrar modal")
                    }, label: {
                        Image(systemName: "arrow.down.circle.fill").font(.largeTitle).foregroundColor(.white)
                    })
                    .padding(.trailing, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                    //TESTEO
                }
            })
        .alert(isPresented: $login.errorRegistro) {
            Alert(title: Text("Error en el Registro"), message: Text("Verifica los requisitos de la contraseña."))
        }
    }
}

struct RegistroView_Previews: PreviewProvider {
    static var previews: some View {
        RegistroView()
    }
}

struct SingleFormView: View {
    
    var fieldName = ""
    @Binding var fieldValue: String
    var isProtected = false
    
    var body: some View{
        VStack{
            if isProtected{
                SecureField(fieldName, text: $fieldValue)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    
            }else{
                TextField(fieldName, text: $fieldValue)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                        
                        
                    
            }
        }
    }
}

struct ValidationFormView: View {
    
    var iconName = "xmark.circle"
    var iconColor = Color.red
    var formText = ""
    var conditionChecked = false
    
    var body: some View {
        HStack{
            Image(systemName: iconName)
                .foregroundColor(iconColor)
            Text(formText)
                .font(.system(.body, design: .rounded))
                .strikethrough(conditionChecked)
                .foregroundColor(.white)
            
            Spacer()
        }.padding(.top, 4)
    }
}
