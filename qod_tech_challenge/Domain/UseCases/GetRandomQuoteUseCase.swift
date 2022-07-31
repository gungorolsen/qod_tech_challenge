//
//  GetRandomQuoteUseCase.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Combine

protocol GetRandomQuoteUseCase {
    func getQuote() -> AnyPublisher<Quote, DomainError>
}

class GetRandomQuoteUseCaseImpl {
    
    private let categoryRepo: CategoryRepo
    private let quoteRepo: QuoteRepo
    
    init(categoryRepo: CategoryRepo = CategoryService(),
         quoteRepo: QuoteRepo = QuoteService()) {
        self.categoryRepo = categoryRepo
        self.quoteRepo = quoteRepo
    }
}



extension GetRandomQuoteUseCaseImpl: GetRandomQuoteUseCase {
    
    func getQuote() -> AnyPublisher<Quote, DomainError> {
        categoryRepo.getCategory()
            .tryMap(getRandomCategory)
            .mapError(DomainError.map)
            .flatMap(quoteRepo.getQuote)
            .mapError(DomainError.map)
            .eraseToAnyPublisher()
        }
    
    private func getRandomCategory(_ category: Category) throws -> String {
        guard let categoryName = category.categories.randomElement()?.key else {
            throw DomainError.noRandomCategory
        }
        return categoryName
    }
}

