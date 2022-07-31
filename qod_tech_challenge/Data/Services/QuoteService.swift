//
//  QuoteService.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Combine

class QuoteService {

    // MARK: Properties
    
    private let httpClient: HTTPClientType
    private let mapper: QuoteMapping
    
    // MARK: Initialiser
    
    init(httpClient: HTTPClientType = HTTPClient(),
         mapper: QuoteMapping = QuoteMapper()) {
        self.httpClient = httpClient
        self.mapper = mapper
    }
}

extension QuoteService: QuoteRepo {
    
    private func getUrlString(for category: String) -> String {
        Endpoints.getUrlString(endpoint: .qod(category))
    }
    
    func getQuote(for categoryName: String) -> AnyPublisher<Quote, DomainError> {
        httpClient.dataTaskPublisher(urlString: getUrlString(for: categoryName))
            .tryMap { try self.mapper.mapToDomain(from: $0) }
            .mapError { DomainError.quote($0) }
            .eraseToAnyPublisher()
    }
}

