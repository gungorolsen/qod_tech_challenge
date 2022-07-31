//
//  CategoryRepo.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Combine

protocol CategoryRepo {
    func getCategory() -> AnyPublisher<Category, DomainError>
}
