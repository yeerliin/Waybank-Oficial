//
//  FirebaseModel.swift
//  Waybank
//
//  Created by yerlin on 30/3/22.
//

import Foundation
import Firebase

struct DatosUsuarios: Identifiable  {
    let id = UUID()
    var apellidos: String?
    var cp: String?
    var descripcion: String?
    var descripcionFondos: String?
    var direccion: String?
    var direccionBanco: String?
    var dni: String?
    var email: String?
    var estado: Bool?
    var estadoCivil: String?
    var fechaAlta: Date?
    var fechaBaja: Date?
    var fechaNacimiento: String?
    var iban: String
    var idCliente: Int?
    var idOficina: Int?
    var idReseller: Int?
    var idioma: String?
    var incremento: Double?
    var ipAlta: String?
    var ipUltima: String?
    var kyc: Bool?
    var moneda: String?
    var nombre: String?
    var pais: String?
    var poblacion: String?
    var profesion: String?
    var provider: String?
    var provincia: String?
    var rangoInversionHasta: Double?
    var rangoInversionDesde: Double?
    var riesgo: Double?
    var sexo: String?
    var swift: String
    var telefono: String?
    var vip: Bool?
    var correoelectronico: String?
    var provenienciaFondos: String?
    var titular: String
    var genero: String?
    var banco: String
    var correoElectronico: String?
}

struct DatosContratosWaybank: Identifiable {
    let id = UUID()
    var TIN: Double
    var cantidadInvertida: Double
    var comisionReseller: Double
    var estadoOperacion: String
    var fechaMovimiento: Date
    var frecuenciaInteres: String
    var idContrato: String
    var interes: Double
    var periodoInversion: Int
    var reinvertir: Bool
    var smartContract: String
    var capital : Double
    var rendimiento : Double
    var saldoTotal : Double
    var frequenciaDePagoContratos : Int
    var periodoInversionDeContratos: Int
    var añosDeDuracion : Int
 }

struct Transaccion: Identifiable {
    var id : String
    var email: String
    var btc: Double
    var transactionDescription, description2: String
    var priceEUR: Double
    var priceUSD: Double
    var Evento: [FechaModificada]
}

struct FechaModificada {
    var id : String
    var dateEvent: Date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM Y"
        return formatter.string(from: dateEvent)
    }
  
}

struct FaqItems: Identifiable {
    var id: String
    var description: String
    var title: String

    }

struct DatosBanco: Identifiable {
    var id : String
    var titular: String?
    var banco: String?
    var iban: String?
    var swift: String?
}

struct DatosKyc: Identifiable {
    var id: String
    var nombre : String
    var apellidos : String
    var direccion : String
    var poblacion : String
    var codigopostal : String
    var provincia : String
    var pais : String
    var telefono : String
    var correo : String
    var estadocivil : String
    var fechanacimiento : String
    var genero : String
    var dni : String
    var fondos : String
    var rangobajo : Double
    var rangoalto : Double
}

struct InversionMinima: Identifiable {
    let id = UUID()
    var minimaInversion: Double
    }

struct Transaction: Identifiable {
    var id : String
    var email: String
    var btc: Double
    var transactionDescription, description2: String
    var priceEUR: Double
    var priceUSD: Double
    var Evento: [Eventos]
}

struct Eventos {
    var id : String
    var dateEvent: Date
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM Y"
        return formatter.string(from: dateEvent)
    }
  
}

struct Interes: Identifiable {
    let id = UUID()
    var anual: Double
    var mensual: Double
    var semestral: Double
    var trimestral: Double
    }

struct Incrementos: Identifiable {
    let id = UUID()
    var resellerIncrementos: Double
   }

struct ReInversion: Identifiable {
    let id = UUID()
    var reInversion: Double
   }

struct MinimaInversion: Identifiable {
    let id = UUID()
    var inversionMinima: Double
   }
