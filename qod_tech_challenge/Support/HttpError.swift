//
//  HttpError.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation

enum HttpError: Error {
    case invalidResponse
    case failure(code: Int)
    case invalidURL(url: String)
    case deserilization
    case error(Error)

    static func map(_ error: Error) -> HttpError {
        (error as? HttpError) ?? .error(error)
    }
}   
