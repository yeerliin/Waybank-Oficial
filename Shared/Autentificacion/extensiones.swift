//
//  extensiones.swift
//  Waybank
//
//  Created by yerlin on 31/3/22.
//

import Foundation
import SwiftUI

extension Date {
    public func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMM/dd/yyyy")
        return dateFormatter.string(from: self)
    }
    public func addMonth(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: n, to: self)!
    }
    public func addYear(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: n, to: self)!
    }
}

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}

extension Double {
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self): String(self)
    }
}

extension Double {
    func roundToPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    func cutOffDecimalAfter(_ places: Int) -> Double{
        let divisor = pow(10.0, Double(places))
        return (self*divisor).rounded(.towardZero) / divisor
    }
}

extension Date {
    func formatDia() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd")
        return dateFormatter.string(from: self)
    }
}
extension Date {
    func formatMes() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MM")
        return dateFormatter.string(from: self)
    }
}
extension Date {
    func formatAño() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy")
        return dateFormatter.string(from: self)
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}

struct OrangeGroupBoxStyle: GroupBoxStyle {
    var background: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.orange)
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .frame(maxWidth: 200, maxHeight: 30)
            .padding()
            .background(background)
            .opacity(0.4)
            .overlay(
                configuration.label
                    .padding(.leading, 4),
                alignment: .topLeading
            )
    }
}
