//
//  API.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 09/10/23.
//

import Foundation

class API {
    
    enum APIError: Error {
        case invalidURL
    }
    
    private static let defaultURLString = "https://rickandmortyapi.com/api/character"
    
    private let urlString: String
    private let networkService: NetworkService
    
    init(
        networkService: NetworkService = RMNetworkService(),
        urlString: String = API.defaultURLString
    ) {
        self.networkService = networkService
        self.urlString = urlString
    }
    
    func getCharacters(
        success: @escaping ((CharactersResponse) -> Void),
        fail: @escaping ((Error?) -> Void)
    ) throws {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        networkService.request(CharactersResponse.self, url: url) { charactersResponse, response, error in
            guard let charactersResponse = charactersResponse, error == nil else {
                fail(error)
                
                return
            }
            
            success(charactersResponse)
        }
    }
}
