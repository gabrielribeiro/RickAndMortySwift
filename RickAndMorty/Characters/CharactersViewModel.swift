//
//  CharactersViewModel.swift
//  RickAndMortyTest
//
//  Created by Gabriel Ribeiro on 05/10/23.
//

import Foundation

protocol CharactersViewControllerDelegate: NSObject {
    func didFail(with error: Error?)
    func didFetchWithSuccess()
    func loadingDidChange(loading: Bool)
}

class CharactersViewModel {
    
    weak var delegate: CharactersViewControllerDelegate?
    
    private (set) var characters: [Character] = []
    
    private let apiClient: API
    
    init(apiClient: API = API()) {
        self.apiClient = apiClient
    }
    
    var selectedCharacter: Character?
    
    func fetchData() {
        
        delegate?.loadingDidChange(loading: true)
        
        apiClient.getCharacters { [weak self] charactersResponse in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.characters = charactersResponse.results
            
            strongSelf.delegate?.loadingDidChange(loading: false)
            
            strongSelf.delegate?.didFetchWithSuccess()
        } fail: { [weak self] error in
            
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.delegate?.loadingDidChange(loading: false)
            
            strongSelf.delegate?.didFail(with: error)
        }
    }
}
