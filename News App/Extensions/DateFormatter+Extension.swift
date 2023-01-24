//
//  DateFormatter+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 20/07/21.
//

import Foundation

extension DateFormatter {
    
    static let defaultDate: DateFormatter = {
        let formatted = DateFormatter()
        formatted.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatted.calendar = Calendar(identifier: .iso8601)
        formatted.locale = Locale(identifier: "pt-BR")
        return formatted
    }()
    
}
