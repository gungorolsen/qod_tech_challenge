//
//  CategoryService.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Combine

class CategoryService {

    // MARK: Properties
    
    private let httpClient: HTTPClientType
    private let mapper: CategoryMapping
    
    // MARK: Initialiser
    
    init(httpClient: HTTPClientType = HTTPClient(),
         mapper: CategoryMapping = CategoryMapper()) {
        self.httpClient = httpClient
        self.mapper = mapper
    }
}

extension CategoryService: CategoryRepo {
        
    func getCategory() -> AnyPublisher<Category, DomainError> {
        httpClient.dataTaskPublisher(urlString: urlString)
            .tryMap { try self.mapper.mapToDomain(from: $0) }
            .mapError { DomainError.category($0) }
            .eraseToAnyPublisher()
    }
    
    private var urlString: String {
        Endpoints.getUrlString(endpoint: .categories)
    }
}

