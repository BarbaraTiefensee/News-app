//
//  Date+Extension.swift
//  News App
//
//  Created by Gabriel Varela on 28/07/21.
//

import Foundation

extension Date{
     
    func setDateString() -> String {
        let date = DateFormatter()
        if let language = Locale.preferredLanguages.first?.uppercased() {
            if language.contains("BR") || language.contains("PT") {
                date.dateFormat = "dd 'de' MMMM"
                date.locale = Locale(identifier: "pt-BR")
            } else {
                date.dateFormat = "dd MMMM"
                date.locale = Locale(identifier: "en-US")
            }
        }
        return date.string(from: self)
    }
}
