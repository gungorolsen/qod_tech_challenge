//
//  QuoteViewModel.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation

class QuoteEmailViewModel {
    let subject: String
    let body: String
    
    init(quote: Quote) {
        self.subject = quote.title
        self.body = String(format: "\"%@\" \n\n by %@", quote.quote, quote.author ?? "Anonymous")
    }
}
