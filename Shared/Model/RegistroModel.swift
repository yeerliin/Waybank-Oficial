//
//  RegistroModel.swift
//  Waybank
//
//  Created by yerlin on 5/4/22.
//
import Foundation
import Combine

class RegistroModel: ObservableObject {
    //TESTEO
    //Entrada de datos del usuario
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    //Valores de validacion del formulario
    @Published var emailLengthValid = false
    @Published var passwordLengthValid = false
    @Published var passwordMatch = false
    @Published var passwordCapitalLetter = false
    @Published var passwordNumber = false
    
    private var cancellableObjects: Set<AnyCancellable> = []
        
        
        //Esto lo eliminare
        init(){
            $email
                .receive(on: RunLoop.main)
                .map{ email in
                    return email.count >= 8
                    
                }
                .assign(to: \.emailLengthValid, on: self)
                .store(in: &cancellableObjects)
        
        $password
            .receive(on: RunLoop.main)
            .map{ password in
                return password.count >= 8
            }
            .assign(to: \.passwordLengthValid, on: self)
            .store(in: &cancellableObjects)
        
        $password
            .receive(on: RunLoop.main)
            .map{ password in
                let patternCapital = "[A-Z]"
                let patternMinus = "[a-z]"
                if let _ = password.range(of: patternCapital, options: .regularExpression){
                    if let _ = password.range(of: patternMinus, options: .regularExpression){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            }
            .assign(to: \.passwordCapitalLetter, on: self)
            .store(in: &cancellableObjects)
        
        $password
            .receive(on: RunLoop.main)
            .map{ password in
                let patternNumber = "[0-9]"
                if let _ = password.range(of: patternNumber, options: .regularExpression){
                    return true
                }else{
                    return false
                }
            }
            .assign(to: \.passwordNumber, on: self)
            .store(in: &cancellableObjects)
        
        Publishers.CombineLatest($password, $confirmPassword)
            .receive(on: RunLoop.main)
            .map{ (password, confirmPassword) in
                return !password.isEmpty && (password == confirmPassword)
            }
            .assign(to: \.passwordMatch, on: self)
            .store(in: &cancellableObjects)
    }
    
}
