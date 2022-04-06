//
//  SimuladorViewModel.swift
//  Waybank
//
//  Created by yerlin on 1/4/22.
//

import Foundation
import SwiftUI

class SimuladorViewModel: ObservableObject {
    
    @ObservedObject var datosFirebase = FirebaseViewModel()
    
    //VARIBLES PUBLICAS
    @Published var añosDeDuracion = 24
    @Published var añosIntDuracion = 4
    @Published var frequenciaDePagos = 1
    @Published var botonSeleccionat = "Anual"
    
    //VARIABLES SWICTH TABLA
    
    //Interes
    @Published  var interesMensual = 0.0
    @Published  var interesTrimestral = 0.0
    @Published  var interesSemestral = 0.0
    @Published  var interesAnual = 0.0
    
    @Published  var interesResumenTae = 0.0
    @Published  var interesResumenTin = 0.0
    
    @Published  var interesMensualSecundario = 0.0
    @Published  var interesTrimestralSecundario = 0.0
    @Published  var interesSemestralSecundario = 0.0
    @Published  var interesAnualSecundario = 0.0
    
    @Published var pagosRealizar = 1 // Repeticiones
    @Published var pagosFecha = 1
    
    func tablaSimulador(duracion: Int, frequencia: Int) {
        datosFirebase.getIntereses()
        switch (duracion, frequencia){
            case (12, 12):
                
                interesMensualSecundario = datosFirebase.interesTae12.mensual
                interesTrimestralSecundario = datosFirebase.interesTae12.trimestral
                interesSemestralSecundario = datosFirebase.interesTae12.semestral
                interesAnualSecundario = datosFirebase.interesTae12.anual
                
                interesMensual = datosFirebase.interesTin12.mensual
                interesTrimestral = datosFirebase.interesTin12.trimestral
                interesSemestral = datosFirebase.interesTin12.semestral
                interesAnual = datosFirebase.interesTin12.anual
                
                interesResumenTae  = datosFirebase.interesTae12.mensual
                interesResumenTin = datosFirebase.interesTin12.mensual
                
                botonSeleccionat = "Mensual"
                print("Correcto 12/12")
                
                pagosFecha = 1
                pagosRealizar = 12
            case (12, 4):
                
                interesMensualSecundario = datosFirebase.interesTae12.mensual
                interesTrimestralSecundario = datosFirebase.interesTae12.trimestral
                interesSemestralSecundario = datosFirebase.interesTae12.semestral
                interesAnualSecundario = datosFirebase.interesTae12.anual
                
                interesMensual = datosFirebase.interesTin12.mensual
                interesTrimestral = datosFirebase.interesTin12.trimestral
                interesSemestral = datosFirebase.interesTin12.semestral
                interesAnual = datosFirebase.interesTin12.anual
                
                interesResumenTae  = datosFirebase.interesTae12.trimestral
                interesResumenTin = datosFirebase.interesTin12.trimestral
                
                botonSeleccionat = "Trimestral"
                print("Correcto 12/4")
                pagosFecha = 3
                pagosRealizar = 4
                
            case (12, 2):
                
                interesMensualSecundario = datosFirebase.interesTae12.mensual
                interesTrimestralSecundario = datosFirebase.interesTae12.trimestral
                interesSemestralSecundario = datosFirebase.interesTae12.semestral
                interesAnualSecundario = datosFirebase.interesTae12.anual
                
                interesMensual = datosFirebase.interesTin12.mensual
                interesTrimestral = datosFirebase.interesTin12.trimestral
                interesSemestral = datosFirebase.interesTin12.semestral
                interesAnual = datosFirebase.interesTin12.anual
                
                interesResumenTae  = datosFirebase.interesTae12.semestral
                interesResumenTin = datosFirebase.interesTin12.semestral
                
                botonSeleccionat = "Semestral"
                print("Correcto 12/2")
                pagosFecha = 6
                pagosRealizar = 2
                
            case (12, 1):
                
                interesMensualSecundario = datosFirebase.interesTae12.mensual
                interesTrimestralSecundario = datosFirebase.interesTae12.trimestral
                interesSemestralSecundario = datosFirebase.interesTae12.semestral
                interesAnualSecundario = datosFirebase.interesTae12.anual
                
                interesMensual = datosFirebase.interesTin12.mensual
                interesTrimestral = datosFirebase.interesTin12.trimestral
                interesSemestral = datosFirebase.interesTin12.semestral
                interesAnual = datosFirebase.interesTin12.anual
                
                interesResumenTae  = datosFirebase.interesTae12.anual
                interesResumenTin = datosFirebase.interesTin12.anual
                
                botonSeleccionat = "Anual"
                print("Correcto 12/1")
                pagosFecha = 12
                pagosRealizar = 1
                
            case (24, 12):
                
                interesMensualSecundario = datosFirebase.interesTae24.mensual
                interesTrimestralSecundario = datosFirebase.interesTae24.trimestral
                interesSemestralSecundario = datosFirebase.interesTae24.semestral
                interesAnualSecundario = datosFirebase.interesTae24.anual
                
                interesMensual = datosFirebase.interesTin24.mensual
                interesTrimestral = datosFirebase.interesTin24.trimestral
                interesSemestral = datosFirebase.interesTin24.semestral
                interesAnual = datosFirebase.interesTin24.anual
                
                interesResumenTae  = datosFirebase.interesTae24.mensual
                interesResumenTin = datosFirebase.interesTin24.mensual
                
                botonSeleccionat = "Mensual"
                pagosRealizar = 24
                pagosFecha = 1
            case (24, 4):
                
                interesMensualSecundario = datosFirebase.interesTae24.mensual
                interesTrimestralSecundario = datosFirebase.interesTae24.trimestral
                interesSemestralSecundario = datosFirebase.interesTae24.semestral
                interesAnualSecundario = datosFirebase.interesTae24.anual
                
                interesMensual = datosFirebase.interesTin24.mensual
                interesTrimestral = datosFirebase.interesTin24.trimestral
                interesSemestral = datosFirebase.interesTin24.semestral
                interesAnual = datosFirebase.interesTin24.anual
                
                interesResumenTae  = datosFirebase.interesTae24.trimestral
                interesResumenTin = datosFirebase.interesTin24.trimestral
                pagosFecha = 3
                botonSeleccionat = "Trimestral"
                print("Correcto 24/4")
                
                pagosRealizar = 8
                
            case (24, 2):
                interesMensualSecundario = datosFirebase.interesTae24.mensual
                interesTrimestralSecundario = datosFirebase.interesTae24.trimestral
                interesSemestralSecundario = datosFirebase.interesTae24.semestral
                interesAnualSecundario = datosFirebase.interesTae24.anual
                
                interesMensual = datosFirebase.interesTin24.mensual
                interesTrimestral = datosFirebase.interesTin24.trimestral
                interesSemestral = datosFirebase.interesTin24.semestral
                interesAnual = datosFirebase.interesTin24.anual
                
                interesResumenTae  = datosFirebase.interesTae24.semestral
                interesResumenTin = datosFirebase.interesTin24.semestral
                
                botonSeleccionat = "Semestral"
                pagosFecha = 6
                pagosRealizar = 4
                
            case (24, 1):
                
                interesMensualSecundario = datosFirebase.interesTae24.mensual
                interesTrimestralSecundario = datosFirebase.interesTae24.trimestral
                interesSemestralSecundario = datosFirebase.interesTae24.semestral
                interesAnualSecundario = datosFirebase.interesTae24.anual
                
                interesMensual = datosFirebase.interesTin24.mensual
                interesTrimestral = datosFirebase.interesTin24.trimestral
                interesSemestral = datosFirebase.interesTin24.semestral
                interesAnual = datosFirebase.interesTin24.anual
                
                interesResumenTae  = datosFirebase.interesTae24.anual
                interesResumenTin = datosFirebase.interesTin24.anual
                
                botonSeleccionat = "Anual"
                pagosRealizar = 2
                pagosFecha = 12
            case (36, 12):
                
                interesMensualSecundario = datosFirebase.interesTae36.mensual
                interesTrimestralSecundario = datosFirebase.interesTae36.trimestral
                interesSemestralSecundario = datosFirebase.interesTae36.semestral
                interesAnualSecundario = datosFirebase.interesTae36.anual
                
                interesMensual = datosFirebase.interesTin36.mensual
                interesTrimestral = datosFirebase.interesTin36.trimestral
                interesSemestral = datosFirebase.interesTin36.semestral
                interesAnual = datosFirebase.interesTin36.anual
                
                interesResumenTae  = datosFirebase.interesTae36.mensual
                interesResumenTin = datosFirebase.interesTin36.mensual
                
                botonSeleccionat = "Mensual"
                print("Correcto 36/12")
                pagosRealizar = 36
                pagosFecha = 1
            case (36, 4):
                
                interesMensualSecundario = datosFirebase.interesTae36.mensual
                interesTrimestralSecundario = datosFirebase.interesTae36.trimestral
                interesSemestralSecundario = datosFirebase.interesTae36.semestral
                interesAnualSecundario = datosFirebase.interesTae36.anual
                
                interesMensual = datosFirebase.interesTin36.mensual
                interesTrimestral = datosFirebase.interesTin36.trimestral
                interesSemestral = datosFirebase.interesTin36.semestral
                interesAnual = datosFirebase.interesTin36.anual
                
                interesResumenTae  = datosFirebase.interesTae36.trimestral
                interesResumenTin = datosFirebase.interesTin36.trimestral
                
                botonSeleccionat = "Trimestral"
                print("Correcto 36/4")
                pagosRealizar = 12
                pagosFecha = 3
            case (36, 2):
                
                interesMensualSecundario = datosFirebase.interesTae36.mensual
                interesTrimestralSecundario = datosFirebase.interesTae36.trimestral
                interesSemestralSecundario = datosFirebase.interesTae36.semestral
                interesAnualSecundario = datosFirebase.interesTae36.anual
                
                interesMensual = datosFirebase.interesTin36.mensual
                interesTrimestral = datosFirebase.interesTin36.trimestral
                interesSemestral = datosFirebase.interesTin36.semestral
                interesAnual = datosFirebase.interesTin36.anual
                
                interesResumenTae  = datosFirebase.interesTae36.semestral
                interesResumenTin = datosFirebase.interesTin36.semestral
                
                botonSeleccionat = "Semestral"
                print("Correcto 36/2")
                pagosRealizar = 6
                pagosFecha = 6
            case (36, 1):
                
                interesMensualSecundario = datosFirebase.interesTae36.mensual
                interesTrimestralSecundario = datosFirebase.interesTae36.trimestral
                interesSemestralSecundario = datosFirebase.interesTae36.semestral
                interesAnualSecundario = datosFirebase.interesTae36.anual
                
                interesMensual = datosFirebase.interesTin36.mensual
                interesTrimestral = datosFirebase.interesTin36.trimestral
                interesSemestral = datosFirebase.interesTin36.semestral
                interesAnual = datosFirebase.interesTin36.anual
                
                interesResumenTae  = datosFirebase.interesTae36.anual
                interesResumenTin = datosFirebase.interesTin36.anual
                
                botonSeleccionat = "Anual"
                print("Correcto 36/1")
                pagosRealizar = 3
                pagosFecha = 12
            case (_, _):
                print("Sin Datos correctos")
        }
    }
    
    func getDuracion(duracion : AñosDeDuracion) {
        switch duracion {
            case .unAño:
                añosDeDuracion = 12
                añosIntDuracion = 1
            case .dosAños:
                añosDeDuracion = 24
                añosIntDuracion = 2
            case .tresAños:
                añosDeDuracion = 36
                añosIntDuracion = 3
        }
    }
    
    func getFrequencia(frequencia : FrequenciaDePago) {
        switch frequencia {
            case .mensual:
                frequenciaDePagos = 12
                botonSeleccionat = "Mensual"
               
                print(botonSeleccionat)
            case .trimestral:
                frequenciaDePagos = 4
                botonSeleccionat = "Trimestral"
                
                print(botonSeleccionat)
            case .semestral:
                frequenciaDePagos = 2
                botonSeleccionat = "Semestral"
                
                print(botonSeleccionat)
            case .anual:
                frequenciaDePagos = 1
               
                botonSeleccionat = "Anual"
                print(botonSeleccionat)
        }
        
    }
    
    func getBotonSeleccionado(mensualidad: String) {
        self.botonSeleccionat = mensualidad
        return
    }
    
    

    
    
    
    
}
