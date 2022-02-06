//
//  Helper.swift
//  ImageSearch
//
//  Created by apurv on 06/02/2022.
//

import Foundation

final class Helper {
    
    ///method to validate the date entered by user
    static func validateDate(date: String) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) != nil
    }
}
