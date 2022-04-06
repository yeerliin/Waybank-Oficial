//
//  FirebaseAutentificacion.swift
//  Waybank
//
//  Created by yerlin on 28/3/22.
//

import Foundation
import Firebase
import Combine
import SwiftUI
import GoogleSignIn
import CryptoKit
import AuthenticationServices

class FirebaseViewModel: ObservableObject {
    
    //CONTANTES FIJAS
    let coleccionUsuarios = "profile"
    
    
    //VARIBLES PUBLICAS
    @Published var showLogin = false
    @Published var datosFaq =  [FaqItems]()
    @Published var datosDelUsuario = DatosUsuarios(apellidos: "", cp: "", descripcion: "", descripcionFondos: "", direccion: "", direccionBanco: "", dni: "", email: "", estado: false, estadoCivil: "", fechaAlta: Date(), fechaBaja: Date(), fechaNacimiento: "", iban: "", idCliente: 0, idOficina: 0, idReseller: 0, idioma: "", incremento: 0.0, ipAlta: "", ipUltima: "", kyc: false, moneda: "", nombre: "", pais: "", poblacion: "", profesion: "", provider: "", provincia: "", rangoInversionHasta: 0.0, rangoInversionDesde: 0.0, riesgo: 0.0, sexo: "", swift: "", telefono: "", vip: false, correoelectronico: "", provenienciaFondos: "", titular: "", genero: "", banco: "")
    @Published var contratosWaybank = [DatosContratosWaybank]()
    @Published var datosEventos = [Eventos]()
    
    //INTERESES
    @Published var interesTae12 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    @Published var interesTae24 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    @Published var interesTae36 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    @Published var interesTin12 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    @Published var interesTin24 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    @Published var interesTin36 = Interes(anual: 0, mensual: 0, semestral: 0, trimestral: 0)
    
    //OTROS
    @Published var incrementosReseller = Incrementos(resellerIncrementos: 0)
    @Published var reInversion = ReInversion(reInversion: 0)
    @Published var inversionMinima = MinimaInversion(inversionMinima: 0)

    //ERRORES ALERTAS
    @Published var errorLogin = false
    @Published var errorRegistro = false
    @Published var errorDatosBancarios = false
    @Published var errorKYC = false
    
    //Inicio de sesion de usuario mediante correo electronico.
    func login(email: String, password: String, completion: @escaping(_ done : Bool) -> Void ){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                print("Iniciamos sesion mediante Email y Password")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("Error del Login desde Firebase", error)
                    self.errorLogin = true
                }else{
                    print("Error del Login desde la APP")
                }
            }
        }
    }
    
    //Creacion de un usuario mediante email y contraseña añadiendo toda las colleciones de la base de datos.
    func crearUsuario(password: String, Apellidos: String, Banco: String, CP: String, Descripcion: String, DescripcionFondos: String, Direccion: String, DireccionBanco: String, DNI: String, email: String, Estado: Bool, EstadoCivil: String, FechaAlta: Date, FechaBaja: Date, FechaNacimiento: String, Iban: String,iDCliente: Int, idOficina: Int, iDReseller: Int, Idioma: String, Incremento: Int, iPAlta: String, iPUltima: String,KYC: Bool, Moneda: String, Nombre: String, Pais: String, Poblacion: String, Profesion: String, Provider: String,Provincia: String, RangoInversionHasta: Int, RangoInversionDesde: Int, Riesgo: Int, Sexo: String, Swift: String, Telefono: String, Vip: Bool, completion: @escaping(_ done : Bool) -> Void ){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            let db = Firestore.firestore()
            if user != nil {
                let campos : [String:Any] = ["apellidos":Apellidos, "banco":Banco, "cp":CP, "descripcion":Descripcion, "descripcionFondos":Descripcion, "direccion":Direccion, "direccionBanco":DireccionBanco, "dni":DNI, "email":email,"estado":Estado, "estadoCivil":EstadoCivil, "fechaAlta":FechaAlta, "fechaBaja":FechaBaja, "fechaNacimiento":FechaNacimiento, "iban":Iban, "idCliente": iDCliente, "idOficina": idOficina, "idReseller":iDReseller, "idioma":Idioma, "incremento":Incremento, "ipAlta":iPAlta, "ipUltima" : iPUltima, "kyc":KYC, "moneda":Moneda, "nombre":Nombre,"pais": Pais, "poblacion":Poblacion, "profesion":Profesion,"provider":Provider, "provincia":Provincia, "rangoInversionHasta":RangoInversionHasta, "rangoInversionDesde":RangoInversionDesde, "riesgo": Riesgo, "sexo":Sexo, "swift":Swift, "telefono":Telefono, "vip":Vip]
                db.collection(self.coleccionUsuarios).document(email).setData(campos){ error in
                    if let error = error?.localizedDescription{
                        print("Error al copiar Registros a Firebase", error)
                    }else{
                        print("Usuario registrado y guardado en la base de datos")
                        completion(true)
                    }
                }
            }else{
                if let error = error?.localizedDescription {
                    print("Este usuario ya esta registrado...", error)
                    self.errorRegistro = true
                }else{
                    print("Crash de Registro de la APP")
                }
            }
        }
    }
    
    //Recuperar contraseña
    func recuperarPass(email: String, completion: @escaping(_ done : Bool) -> Void ){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                print("Entro y se registro")
                completion(true)
            }else{
                if let error = error?.localizedDescription {
                    print("Error en Firebase", error)
                    self.errorRegistro = true
                }else{
                    print("Error en la app")
                }
            }
        }
    }
    
    //Para hacer lecturas de firebase INDIVIDUAL
    func getDatosUsuario(){
        let db = Firestore.firestore()
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection(self.coleccionUsuarios).document(email).addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let email = valor?.documentID ?? email
                let apellidos = valor?.get("apellidos") as? String ?? "Sin Apellidos"
                let cp = valor?.get("cp") as? String ?? "CP sin datos"
                let descripcion = valor?.get("description") as? String ?? "Sin Descripcion"
                let descripcionFondos = valor?.get("descripcionFondos") as? String ?? "Sin Descripcion"
                let direccion  = valor?.get("direccion")  as? String ?? "Sin Direccion"
                let direccionBanco  = valor?.get("direccionBanco")  as? String ?? "direccionBanco"
                let dni = valor?.get("dni") as? String ?? "Sin dni"
                let estado = valor?.get("estado") as? Bool ?? false
                let estadoCivil = valor?.get("estadoCivil")  as? String ?? "Sin estado Civil"
                let fechaAlta = (valor?.get("fechaAlta") as? Timestamp)?.dateValue() ?? Date()
                let fechaBaja = (valor?.get("fechaBaja") as? Timestamp)?.dateValue() ?? Date()
                let fechaNacimiento = valor?.get("fechaNacimiento") as? String ?? ""
                let iban = valor?.get("iban") as? String ?? "iban"
                let idCliente  = valor?.get("idCliente")  as? Int ?? 0
                let idOficina  = valor?.get("idOficina") as? Int ?? 0
                let idReseller  = valor?.get("idReseller")  as? Int ?? 0
                let idioma  = valor?.get("idioma")  as? String ?? "Sin idioma"
                let incremento  = valor?.get("incremento")  as? Double ?? 0
                let ipAlta = valor?.get("ipAlta") as? String ?? "Sin ipAlta"
                let ipUltima  = valor?.get("ipUltima")  as? String ?? "Sin ipUltima"
                let kyc = valor?.get("kyc") as? Bool ?? false
                let moneda  = valor?.get("moneda")  as? String ?? "Sin moneda"
                let nombre = valor?.get("nombre") as? String ?? "Sin nombre"
                let pais  = valor?.get("pais")  as? String ?? "Sin moneda"
                let poblacion = valor?.get("poblacion") as? String ?? "Sin poblacion"
                let profesion  = valor?.get("profesion")  as? String ?? "Sin profesion"
                let provider = valor?.get("provider") as? String ?? "Sin provider"
                let provincia = valor?.get("provincia") as? String ?? "Sin provincia"
                let rangoInversionHasta  = valor?.get("rangoInversionHasta")  as? Double ?? 0
                let rangoInversionDesde  = valor?.get("rangoInversionDesde")  as? Double ?? 0
                let riesgo = valor?.get("riesgo")  as? Double ?? 0
                let sexo  = valor?.get("sexo")  as? String ?? "Sin sexo"
                let swift = valor?.get("swift") as? String ?? "Sin swift"
                let telefono = valor?.get("telefono") as? String ?? "Sin telefono"
                let vip = valor?.get("vip") as? Bool ?? false
                let correoelectronico = valor?.get("email") as? String ?? ""
                let provenienciaFondos = valor?.get("provenienciaFondos") as? String ?? ""
                let titular = valor?.get("titular") as? String ?? ""
                let genero = valor?.get("genero") as? String ?? ""
                let banco = valor?.get("banco") as? String ?? ""
                let correoElectronico = valor?.get("email") as? String ?? ""
                DispatchQueue.main.async {
                    self.datosDelUsuario = .init(apellidos: apellidos, cp: cp, descripcion: descripcion, descripcionFondos: descripcionFondos, direccion: direccion, direccionBanco: direccionBanco, dni: dni, email: email, estado: estado, estadoCivil: estadoCivil, fechaAlta: fechaAlta, fechaBaja: fechaBaja, fechaNacimiento: fechaNacimiento, iban: iban, idCliente: idCliente, idOficina: idOficina, idReseller: idReseller, idioma: idioma, incremento: incremento, ipAlta: ipAlta, ipUltima: ipUltima, kyc: kyc, moneda: moneda, nombre: nombre, pais: pais, poblacion: poblacion, profesion: profesion, provider: provider, provincia: provincia, rangoInversionHasta: rangoInversionHasta, rangoInversionDesde: rangoInversionDesde, riesgo: riesgo, sexo: sexo, swift: swift, telefono: telefono, vip: vip, correoelectronico: correoelectronico, provenienciaFondos: provenienciaFondos, titular: titular, genero: genero, banco: banco, correoElectronico: correoElectronico)
                }
            }
        }
    }
    
    //Hacer lectura de los contratos creados.
    func getDatosContratos(){ // CONTRATOS
            let db = Firestore.firestore()
            guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
            db.collection("profile/\(email)/waybank/").addSnapshotListener { [self] (QuerySnapshot, error) in //NOTA PARA ESTA LINEA ARRIBA
                if let error = error?.localizedDescription{
                    print("Error al mostrar datos", error)
                }else {
                    self.contratosWaybank.removeAll()
                    for document in QuerySnapshot!.documents {
                        let valor = document.data()
                        _ = document.documentID
                        let tin = valor["TIN"] as? Double ?? 0
                        let cantidadInvertida = valor["cantidadInvertida"] as? Double ?? 0
                        let comisionReseller = valor["comisionReseller"] as? Double ?? 0
                        let estadoOperacion = valor["estadoOperacion"] as? String ?? "Sin Estado Operacion"
                        let fechaMovimiento = (valor["fechaMovimiento"] as? Timestamp)?.dateValue() ?? Date()
                        let frecuenciaInteres  = valor["frecuenciaInteres"]  as? String ?? "frecuenciaInteres"
                        let idContrato  = valor["idContrato"]  as? String ?? "Sin idContrato"
                        let interes = valor["interes"] as? Double ?? 0
                        let periodoInversion = valor["periodoInversion"] as? Int ?? 0
                        let reinvertir = valor["reinvertir"] as? Bool ?? false
                        let smartContract = valor["smartContract"] as? String ?? "Sin SmartContract"
                        var capital = 0.0
                        var rendimiento = 0.0
                        var saldoTotal = 0.0
                        var frequenciaDePagoContratos  = 1
                        var periodoInversionDeContratos = 1
                        var añosDeDuracion = 1
                        if estadoOperacion == "Activo" {
                            capital = cantidadInvertida
                            rendimiento =  cantidadInvertida * tin / 100
                            saldoTotal += cantidadInvertida
                        }
                        switch (frecuenciaInteres, periodoInversion)  {
                            case ("Mensual", 12):
                                frequenciaDePagoContratos = 12
                                periodoInversionDeContratos = 1
                                añosDeDuracion = 1
                                
                            case ("Trimestral", 12):
                                frequenciaDePagoContratos = 4
                                periodoInversionDeContratos = 3
                                añosDeDuracion = 1
                            case ("Semestral", 12):
                                frequenciaDePagoContratos = 2
                                periodoInversionDeContratos = 6
                                añosDeDuracion = 1
                            case ("Anual", 12):
                                frequenciaDePagoContratos = 1
                                periodoInversionDeContratos = 12
                                añosDeDuracion = 1
                                
                            case ("Mensual", 24):
                                frequenciaDePagoContratos = 24
                                periodoInversionDeContratos = 1
                                añosDeDuracion = 2
                                
                            case ("Trimestral", 24):
                                frequenciaDePagoContratos = 8
                                periodoInversionDeContratos = 3
                                añosDeDuracion = 2
                                
                            case ("Semestral", 24):
                                frequenciaDePagoContratos = 4
                                periodoInversionDeContratos = 6
                                añosDeDuracion = 2
                                
                            case ("Anual", 24):
                                frequenciaDePagoContratos = 2   // Repetir
                                periodoInversionDeContratos = 12    // Saltos en meses
                                añosDeDuracion = 2
                                
                            case ("Mensual", 36):
                                frequenciaDePagoContratos = 36
                                periodoInversionDeContratos = 1
                                añosDeDuracion = 3
                                
                            case ("Trimestral", 36):
                                frequenciaDePagoContratos = 12
                                periodoInversionDeContratos = 3
                                
                                añosDeDuracion = 3
                            case ("Semestral", 36):
                                frequenciaDePagoContratos = 6
                                periodoInversionDeContratos = 6
                                añosDeDuracion = 3
                                
                            case ("Anual", 36):
                                frequenciaDePagoContratos = 3
                                periodoInversionDeContratos = 12
                                añosDeDuracion = 3
                                
                            default:
                                print("Error Switch frequencia interes")
                            
                        }
                        
                        DispatchQueue.main.async {
                            let registros = DatosContratosWaybank(TIN: tin, cantidadInvertida: cantidadInvertida, comisionReseller: comisionReseller, estadoOperacion: estadoOperacion, fechaMovimiento: fechaMovimiento, frecuenciaInteres: frecuenciaInteres, idContrato: idContrato, interes: interes, periodoInversion: periodoInversion, reinvertir: reinvertir, smartContract: smartContract,  capital: capital, rendimiento: rendimiento, saldoTotal: saldoTotal, frequenciaDePagoContratos: frequenciaDePagoContratos, periodoInversionDeContratos: periodoInversionDeContratos, añosDeDuracion: añosDeDuracion)
                           
                            self.contratosWaybank.append(registros)
                            
                            
                            
                            //Para añadir otro campo en la funcionde lecturas, lo que tenemos que hacer es añadirlo mediante el let ***.. y luego añadirlo en el FirebaseModel y su tipo si es un String, un Int etc...,
                            
                        }
                        
                    }
                    
                    
                }
            }
        }
    //Creacion o modificacion de los datos bancarios.
    func getDatosDelBanco(titular: String, banco: String, iban: String, swift: String, completion: @escaping (_ done: Bool ) -> Void ){
            let db = Firestore.firestore()
            guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
            let campos : [String:Any] = ["titular": titular, "banco": banco, "iban": iban, "swift": swift]
           db.collection(self.coleccionUsuarios).document(email).setData(campos, merge: true){error in
                if let error = error?.localizedDescription{
                    print("Error al guardar en firebase", error)
                    self.errorDatosBancarios = true
                }else{
                    print("Todo Guardado")
                    completion(true)
                }
            }
        }
    
    //Datos para el KYC
    func getDatosDelKYC(nombre: String, apellidos: String, direccion: String, poblacion: String, codigopostal: String, provincia: String, pais: String, telefono: String, correo: String, estadocivil: String, fechadenacimiento: String, genero: String, dni: String, fondos: String, rangoalto: Double, rangobajo: Double, completion: @escaping (_ done: Bool ) -> Void ){
           let db = Firestore.firestore()
           guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
           let campos : [String:Any] = ["nombre": nombre, "apellidos": apellidos, "direccion": direccion, "poblacion": poblacion, "cp": codigopostal, "provincia": provincia, "pais": pais, "telefono": telefono, "email": correo, "estadoCivil": estadocivil, "fechadenacimiento": fechadenacimiento, "genero": genero, "dni": dni, "provenienciaFondos": fondos, "rangoInversionHasta": rangoalto, "rangoInversionDesde": rangobajo]
           
           db.collection(self.coleccionUsuarios).document(email).setData(campos, merge: true){error in
               if let error = error?.localizedDescription{
                   print("Error al guardar en firebase", error)
                   self.errorKYC = true
               }else{
                   print("Todo Guardado")
                   completion(true)
               }
           }
       }
    
    //Funcion para coger todas las FAQ
    func getDatosFaq(){
           let db = Firestore.firestore()
           db.collection("settings/faq/items").addSnapshotListener { [self] (QuerySnapshot, error) in //NOTA PARA ESTA LINEA ARRIBA
               if let error = error?.localizedDescription{
                   print("Error al mostrar datos", error)
               }else {
                   print("Dentro de FAQ")
                   for document in QuerySnapshot!.documents {
                       let valor = document.data()
                       let id = document.documentID
                       let description = valor["description"] as? String ?? "Sin description"
                       let title = valor["title"] as? String ?? "Sin title"
                   DispatchQueue.main.async {
                       let registros = FaqItems(id: id, description: description, title: title)
                     
                       print(registros)
                       self.datosFaq.append(registros)
                    
                   }
               }
           }
       }
    }
    
    //PARA COGER FECHAS FORMATEADAS
    func getEventos(){
        let db = Firestore.firestore()
        guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
        db.collection("users/\(email)/Historical").addSnapshotListener { (QuerySnapshot, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                self.datosEventos.removeAll()
                for document in QuerySnapshot!.documents {
                    let valor = document.data()
                    let id = document.documentID
                    let fecha = (valor["DATA"] as? Timestamp)?.dateValue() ?? Date()
                    
                    DispatchQueue.main.async {
                        let registros = Eventos(id: id, dateEvent: fecha)
                        self.datosEventos.append(registros)
                        //
                        //Para añadir otro campo en la funcionde lecturas, lo que tenemos que hacer es añadirlo mediante el let ***.. y luego añadirlo en el FirebaseModel y su tipo si es un String, un Int etc...,
                        
                    }
                }
            }
        }
    }
    
    //Crear contratos
    func creacionContrato(TIN:Double, cantidadInvertida:Double, comisionReseller:Double, estadoOperacion:String, fechaMovimiento:Date, frecuenciaInteres: String, idContrato:String, interes:Double,periodoInversion:Int,reinvertir:Bool, smartContract:String, completion: @escaping (_ done: Bool ) -> Void ){
        let db = Firestore.firestore()
        // let id = UUID().uuidString // Generamos una id alphanumerica para cada usuario (No eliminar, puede servirte mas adelante)
        // guard let idUser = Auth.auth().currentUser?.uid else { return } // id del usuario actual.
        guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
        let tiempoIdContrato = Date().timeIntervalSince1970.rounded().cleanValue
        let fechaDia = Date().formatDia()
        let fechaMes = Date().formatMes()
        let fechaAño = Date().formatAño()
        let campos : [String:Any] = ["TIN":TIN, "cantidadInvertida":cantidadInvertida, "comisionReseller":comisionReseller, "estadoOperacion":estadoOperacion, "fechaMovimiento":fechaMovimiento, "frecuenciaInteres":frecuenciaInteres, "idContrato":idContrato, "interes":interes, "periodoInversion":periodoInversion, "reinvertir":reinvertir, "smartContract":smartContract]
        
        let contract : [String:Any] = ["cantidadInvertida":cantidadInvertida,"fechaMovimiento":fechaMovimiento,"idContrato":idContrato]
        
        //"users/\(email)/Historical"
        //Los datos que se guardaran
        db.collection("profile/\(email)/waybank").document("\(tiempoIdContrato)").setData(campos){error in
            if let error = error?.localizedDescription{
                print("Error al guardar en firebase", error)
                self.errorRegistro = true
            }else{
                print("Coleccion Usuario")
                db.collection("contract/\(fechaDia)-\(fechaMes)-\(fechaAño)/waybank").document("\(email)-\(tiempoIdContrato)").setData(contract){error in
                    if let error = error?.localizedDescription{
                        print("Error al guardar en firebase", error)
                        self.errorRegistro = true
                    }else{
                        print("Coleccion Contract")
                        completion(true)
                    }
                }
                completion(true)
            }
        }
    }
    
    //Eliminar contrato
    func delete(idContrato: String, fechaDia: String, fechaMes: String, fechaAño: String){
        guard let email = Auth.auth().currentUser?.email else { return }
        let db = Firestore.firestore()
        db.collection("profile/\(email)/waybank").document("\(idContrato)").delete()
        db.collection("contract/\(fechaDia)-\(fechaMes)-\(fechaAño)/waybank").document("\(email)-\(idContrato)").delete()
    }
    
    //Haces una peticion para remplazar los datos, gracias al campos, merge: true
    func DatosDelKYC(nombre: String, apellidos: String, direccion: String, poblacion: String, codigopostal: String, provincia: String, pais: String, telefono: String, correo: String, estadocivil: String, fechadenacimiento: String, genero: String, dni: String, fondos: String, rangoalto: Double, rangobajo: Double, completion: @escaping (_ done: Bool ) -> Void ){
        let db = Firestore.firestore()
        
        guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
        let campos : [String:Any] = ["nombre": nombre, "apellidos": apellidos, "direccion": direccion, "poblacion": poblacion, "cp": codigopostal, "provincia": provincia, "pais": pais, "telefono": telefono, "email": correo, "estadoCivil": estadocivil, "fechadenacimiento": fechadenacimiento, "genero": genero, "dni": dni, "provenienciaFondos": fondos, "rangoInversionHasta": rangoalto, "rangoInversionDesde": rangobajo]
        
        db.collection("profile").document(email).setData(campos, merge: true){error in
            if let error = error?.localizedDescription{
                print("Error al guardar en firebase", error)
                self.errorRegistro = true
            }else{
                print("Todo Guardado")
                completion(true)
            }
        }
    }
    
    //Datos del Banco
    func DatosDelBanco(titular: String, banco: String, iban: String, swift: String, completion: @escaping (_ done: Bool ) -> Void ){
        let db = Firestore.firestore()
        guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
        let campos : [String:Any] = ["titular": titular, "banco": banco, "iban": iban, "swift": swift]
        db.collection("profile").document(email).setData(campos, merge: true){error in
            if let error = error?.localizedDescription{
                print("Error al guardar en firebase", error)
                self.errorRegistro = true
            }else{
                print("Todo Guardado")
                completion(true)
            }
        }
    }
    
    //PETICIONES DE LA CARPETA INTERESES
    func getIntereses(){
        let db = Firestore.firestore()
        //TAE12
        db.collection("interest").document("tae12").addSnapshotListener { (valor, error) in
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                DispatchQueue.main.async {
                    self.interesTae12 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //TAE24
        db.collection("interest").document("tae24").addSnapshotListener { (valor, error) in
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                
                DispatchQueue.main.async {
                    self.interesTae24 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //TAE36
        db.collection("interest").document("tae36").addSnapshotListener { (valor, error) in
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                
                DispatchQueue.main.async {
                    self.interesTae36 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //TIN12
        db.collection("interest").document("tin12").addSnapshotListener { (valor, error) in
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                DispatchQueue.main.async {
                    self.interesTin12 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //TIN24
        db.collection("interest").document("tin24").addSnapshotListener { (valor, error) in
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                DispatchQueue.main.async {
                    self.interesTin24 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //TIN36
        db.collection("interest").document("tin36").addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let anual = valor?.get("Anual") as? Double ?? 0
                let mensual = valor?.get("Mensual") as? Double ?? 0
                let semestral = valor?.get("Semestral") as? Double ?? 0
                let trimestral = valor?.get("Trimestral") as? Double ?? 0
                DispatchQueue.main.async {
                    self.interesTin36 = .init(anual: anual, mensual: mensual, semestral: semestral, trimestral: trimestral)
                }
            }
        }
        
        //Incrementos
        db.collection("interest").document("incrementos").addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let resellerIncrementos = valor?.get("resellerIncrementos") as? Double ?? 0
                DispatchQueue.main.async {
                    self.incrementosReseller = .init(resellerIncrementos: resellerIncrementos)
                }
            }
        }
        
        //Reinversion
        db.collection("interest").document("reInv").addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let resellerIncrementos = valor?.get("reInversion") as? Double ?? 0
                DispatchQueue.main.async {
                    self.reInversion = .init(reInversion: resellerIncrementos)
                }
            }
        }
        
        //InversionMinima
        db.collection("interest").document("saldo").addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
            if let error = error?.localizedDescription{
                print("Error al mostrar datos", error)
            }else {
                let inversionMinima = valor?.get("minimaInversion") as? Double ?? 0
                DispatchQueue.main.async {
                    self.inversionMinima = .init(inversionMinima: inversionMinima)
                }
            }
            
        }
    }
    
    func getVerificadorInversionMinima(minimo: Double, capital: Double, showAlerta: Bool ) -> (Bool) {
        if capital < minimo {
            let alertaCapital = false
            print(alertaCapital)
            return (alertaCapital)
        }else{
            let alertaCapital = true
            print(alertaCapital)
            return (alertaCapital)
        }
    
    }
    
    //Calculos Varios
    func getCapital(sumaCapital: Double) ->  Double {
           var sumaCapital = 0.0
           for value in contratosWaybank {
               sumaCapital += Double(value.capital)
               print("getCapital", sumaCapital)
           }
           return sumaCapital
        }
    func getRendimiento(sumaRendimiento: Double) ->  Double {
        var sumaRendimiento = 0.0
        for value in contratosWaybank {
            sumaRendimiento += Double(value.rendimiento)
            print("getRendimiento", sumaRendimiento)
        }
        return sumaRendimiento
    }
    func getSumaTotal(sumaTotal: Double) ->  Double {
        var sumaTotalCapital = 0.0
        var sumaTotalRendimiento = 0.0
        var sumaTotal = 0.0
        for value in contratosWaybank {
            sumaTotalCapital += Double(value.capital)
            sumaTotalRendimiento += Double(value.rendimiento)
            sumaTotal = sumaTotalCapital + sumaTotalRendimiento
            print("getSumaTotal", sumaTotal)
        }
        return sumaTotal
    }
    
    //Verificador de Colecciones
    func getVerificadorDeColeccion(){
         let db = Firestore.firestore()
         guard let email = Auth.auth().currentUser?.email else {return }
         // let consulta:String = "user/" + email// Email del usuario actual.
         db.collection("profile").document(email).addSnapshotListener { (valor, error) in //NOTA PARA ESTA LINEA ARRIBA
             if let error = error?.localizedDescription{
                 print("Error al mostrar datos", error)
             }
             if ((valor != nil) && valor!.exists){
                     //Existe la coleccion
                 print("Ya tiene coleccion!")
                 }
                 else {
                     print("coleccion creada")
                     //crear el registro
                     /*Modificar correo que crea las colecciones
                       1-*/
                     self.registroFirebase(Apellidos: "", Banco: "", CP: "", Descripcion: "", DescripcionFondos: "", Direccion: "", DireccionBanco: "", DNI: "", Email: "", Estado: false, EstadoCivil: "", FechaAlta: Date(), FechaBaja: Date(), FechaNacimiento: Date(), Iban: "",iDCliente: 0, idOficina: 0, iDReseller: 0, Idioma: "", Incremento: 0, iPAlta: "", iPUltima: "",KYC: false, Moneda: "", Nombre: "", Pais: "", Poblacion: "", Profesion: "", Provider: "",Provincia: "", RangoInversionHasta: 0, RangoInversionDesde: 0, Riesgo: 0, Sexo: "", Swift: "", Telefono: "", Vip: false) { done in
                         if done {
                             UserDefaults.standard.set(true, forKey: "sesion")
                             self.showLogin.toggle()
                             print("coleccion creada")
                         }else{
                             print("Error al crear coleccion")
                         }
                       
                     }
                         
                // self.datosVerificados.removeAll()
                 
                 }
         }
         }
    
    func registroFirebase(Apellidos: String, Banco: String, CP: String, Descripcion: String, DescripcionFondos: String, Direccion: String, DireccionBanco: String, DNI: String, Email: String, Estado: Bool, EstadoCivil: String, FechaAlta: Date, FechaBaja: Date, FechaNacimiento: Date, Iban: String,iDCliente: Int, idOficina: Int, iDReseller: Int, Idioma: String, Incremento: Int, iPAlta: String, iPUltima: String,KYC: Bool, Moneda: String, Nombre: String, Pais: String, Poblacion: String, Profesion: String, Provider: String,Provincia: String, RangoInversionHasta: Int, RangoInversionDesde: Int, Riesgo: Int, Sexo: String, Swift: String, Telefono: String, Vip: Bool, completion: @escaping (_ done: Bool ) -> Void ){
           let db = Firestore.firestore() // Nos conectamos con la base de datos de firestore
           // let btcKey = UUID().uuidString deberia coger la btcKey de la lista privada.
           // let id = UUID().uuidString // Generamos una id alphanumerica para cada usuario (No eliminar, puede servirte mas adelante)
           guard let idUser = Auth.auth().currentUser?.uid else { return } // id del usuario actual.
           guard let email = Auth.auth().currentUser?.email else { return } // Email del usuario actual.
           let campos : [String:Any] = ["apellidos":Apellidos, "banco":Banco, "cp":CP, "descripcion":Descripcion, "descripcionFondos":Descripcion, "direccion":Direccion, "direccionBanco":DireccionBanco, "dni":DNI, "email":Email,"estado":Estado, "estadoCivil":EstadoCivil, "fechaAlta":FechaAlta, "fechaBaja":FechaBaja, "fechaNacimiento":FechaNacimiento, "iban":Iban, "idCliente": iDCliente, "idOficina": idOficina, "idReseller":iDReseller, "idioma":Idioma, "incremento":Incremento, "ipAlta":iPAlta, "ipUltima" : iPUltima, "kyc":KYC, "moneda":Moneda, "nombre":Nombre,"pais": Pais, "poblacion":Poblacion, "profesion":Profesion,"provider":Provider, "provincia":Provincia, "rangoInversionHasta":RangoInversionHasta, "rangoInversionDesde":RangoInversionDesde, "riesgo": Riesgo, "sexo":Sexo, "swift":Swift, "telefono":Telefono, "vip":Vip   ] //Los datos que se guardaran
           db.collection("profile").document(email).setData(campos){error in
               if let error = error?.localizedDescription{
                   print("Error al guardar en firebase", error)
                   self.errorRegistro = true
               }else{
                   print("Todo Guardado")
                   completion(true)
               }
           }
       }
     
    
    //Final de la Clase v
}

 
