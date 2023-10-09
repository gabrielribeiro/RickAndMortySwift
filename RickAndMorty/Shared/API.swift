//
//  API.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 09/10/23.
//

import Foundation

class API {
    
    private let urlString = "https://rickandmortyapi.com/api/character"
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = RMNetworkService()) {
        self.networkService = networkService
    }
    
    func getCharacters(
        success: @escaping ((CharactersResponse) -> Void),
        fail: @escaping ((Error?) -> Void)
    ) {
        guard let url = URL(string: urlString) else {
            fatalError("URL in incorrect format")
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
