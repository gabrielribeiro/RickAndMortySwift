//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 09/10/23.
//

import Foundation

protocol NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void)
}

class RMNetworkService: NetworkService {
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            do {
                let decodedObject = try newJSONDecoder().decode(type, from: data)
                completionHandler(decodedObject, response, nil)
            } catch {
                completionHandler(nil, response, error)
            }
        }
        task.resume()
    }
}
