//
//  GetValidEmailAddressesUseCase.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//
import Foundation
protocol GetValidEmailAddressesUseCase {
    func extractEmailAddresses(from string: String?) -> [String]
}

class GetValidEmailAddressesUseCaseImpl: GetValidEmailAddressesUseCase {
    
    func extractEmailAddresses(from string: String?) -> [String] {
        guard let string = string else { return [] }
        let emails = string.split(separator: ",").map { String($0).trimmed }
        return emails.filter { $0.isValidEmail }
    }
}
