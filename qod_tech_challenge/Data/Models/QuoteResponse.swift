//
//  Quote.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

struct QuoteResponse: Decodable {
    
    let contents: Contents?
    
    struct Contents: Decodable {
        let quotes: [Quote]?
    }

    struct Quote: Decodable {
        let quote: String?
        let title: String?
        let author: String?
    }
}
