//
//  HttpClient.swift
//  qod_tech_challenge
//
//  Created by Oguzhan Gungor on 31/7/2022.
//

import Foundation
import Combine

protocol HTTPClientType {
    func dataTaskPublisher<T: Decodable>(urlString: String) -> AnyPublisher<T, HttpError>
}

class HTTPClient: HTTPClientType {
    
    private let urlSessionProvider: URLSessionProviding
    
    init(urlSessionProvider: URLSessionProviding = URLSessionProvider()) {
        self.urlSessionProvider = urlSessionProvider
    }
    
    func dataTaskPublisher<T: Decodable>(urlString: String) -> AnyPublisher<T, HttpError> {
        guard let url = URL(string: urlString) else {
            return Fail(error: HttpError.invalidURL(url: urlString)).eraseToAnyPublisher()
        }
    
        return urlSessionProvider
            .dataTaskPublisher(for: url)
            .tryMap { element -> T in
                guard let httpResponse = element.response as? HTTPURLResponse else {
                    throw HttpError.invalidResponse
                }
                if httpResponse.statusCode != 200 {
                    throw HttpError.failure(code: httpResponse.statusCode)
                }
                
                return try JSONDecoder().decode(T.self, from: element.data)
            }
            .mapError { HttpError.map($0) }
            .eraseToAnyPublisher()
    }
}

protocol URLSessionProviding {
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher
}

class URLSessionProvider: URLSessionProviding {
    func dataTaskPublisher(for url: URL) -> URLSession.DataTaskPublisher {
        URLSession.shared.dataTaskPublisher(for: url)
    }
}
