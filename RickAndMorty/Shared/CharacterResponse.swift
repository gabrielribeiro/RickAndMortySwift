//
//  CharactersResponse.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 26/09/23.
//

import Foundation

struct CharactersResponse: Codable {
    let info: Info
    let results: [Character]
}

struct Info: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}

struct Character: Codable, Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
//    let origin, location: Location
    let image: String?
//    let episode: [String]?
//    let url: String?
//    let created: String?
}

//struct Location: Codable {
//    let name: String
//    let url: String
//}
