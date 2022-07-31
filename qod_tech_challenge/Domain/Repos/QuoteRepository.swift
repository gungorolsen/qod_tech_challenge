//
//  QuoteRepo.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation
import Combine

protocol QuoteRepo {
    func getQuote(for categoryName: String) -> AnyPublisher<Quote, DomainError>
}
