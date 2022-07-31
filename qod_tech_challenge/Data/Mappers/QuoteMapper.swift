//
//  QuoteMapper.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation

protocol QuoteMapping {
    func mapToDomain(from response: QuoteResponse) throws -> Quote
}

class QuoteMapper: QuoteMapping {
    
    func mapToDomain(from response: QuoteResponse) throws -> Quote {
        guard let quote = response.contents?.quotes?.first?.quote,
              let title = response.contents?.quotes?.first?.title else {
            throw DomainError.mapping
        }
        let author = response.contents?.quotes?.first?.author
        return Quote(quote: quote, title: title, author: author)
    }
}
