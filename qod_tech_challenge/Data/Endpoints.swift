//
//  Endpoints.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

struct Endpoints {
    
    private static let baseUrl = "http://quotes.rest"
    
    enum Endpoint {
        case categories
        case qod(String)
        
        var path: String {
            switch self {
            case .categories: return "/qod/categories.json"
            case .qod(let category): return "/qod.json?category=" + category
            }
        }
    }
    
    static func getUrlString(endpoint: Endpoint) -> String {
        baseUrl + endpoint.path
    }
}
