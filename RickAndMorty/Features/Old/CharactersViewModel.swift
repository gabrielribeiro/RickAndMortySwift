//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 26/09/23.
//

import Foundation

protocol CharactersViewControllerDelegate: NSObject {
    func didFetchWithSuccess()
    func didFailFetching(with error: Error?)
    func loadingStateDidChange(loading: Bool)
}

class CharactersViewModel {
    
    weak var delegate: CharactersViewController?
    
    private(set) var characters = [Character]()
    private var pagination: Info?
    private var urlSessionTask: URLSessionTask?
    
    func fetch() {
        self.delegate?.loadingStateDidChange(loading: false)
//        self.urlSessionTask?.cancel()
        
        var urlString = "https://rickandmortyapi.com/api/character/"
        
        if let nextUrl = pagination?.next {
            urlString = nextUrl
        }
        
        guard let url = URL(string: urlString) else {
            fatalError("Incorrect URL string")
        }
        
        self.urlSessionTask = URLSession.shared.characterResponseTask(with: url) { [weak self] characterResponse, response, error in
            
            guard let characterResponse = characterResponse, error == nil else {
                self?.delegate?.loadingStateDidChange(loading: false)
                
                self?.delegate?.didFailFetching(with: error)
                
                return
            }
            
            self?.characters.append(contentsOf: characterResponse.results)
            
            self?.pagination = characterResponse.info
            
            self?.delegate?.loadingStateDidChange(loading: false)
            self?.delegate?.didFetchWithSuccess()
        }
        
        self.delegate?.loadingStateDidChange(loading: true)
        
        self.urlSessionTask?.resume()
    }
}
