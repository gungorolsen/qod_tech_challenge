//
//  ViewController.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

struct CategoryResponse: Decodable {
    let contents: Contents?

    struct Contents: Decodable {
        let categories: [String: String]?
    }
}

