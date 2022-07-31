//
//  CategoryMapper.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

protocol CategoryMapping {
    func mapToDomain(from response: CategoryResponse) throws -> Category
}

class CategoryMapper: CategoryMapping {
    
    func mapToDomain(from response: CategoryResponse) throws -> Category {
        guard let categories = response.contents?.categories else {
            throw DomainError.mapping
        }
        return Category(categories: categories)
    }
}
