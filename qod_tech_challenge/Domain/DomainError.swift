//
//  DomainError.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation

enum DomainError: Error {
    case quote(Error)
    case category(Error)
    case mapping
    case noRandomCategory
    case unexpected(Error)
    
    static func map(_ error: Error) -> DomainError {
        if let error = error as? DomainError {
            return error
        }
        return .unexpected(error)
    }

}
