//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 10/10/23.
//

import Foundation

protocol CharacterDetailViewControllerDelegate: NSObject {
    func didSetData(character: Character)
}

class CharacterDetailViewModel {
    
    enum RowType {
        case name, status, species, type, gender
        
        var title: String {
            switch self {
            case .name:
                return "Name"
            case .status:
                return "Status"
            case .species:
                return "Species"
            case .type:
                return "Type"
            case .gender:
                return "Gender"
            }
        }
    }
    
    struct Row {
        var value: String
        var rowType: RowType
    }
    
    weak var delegate: CharacterDetailViewControllerDelegate?
    
    private (set) var items: [Row] = []
    
    func setData(for character: Character) {
        items = [
            .init(value: character.name, rowType: .name),
            .init(value: character.status, rowType: .status),
            .init(value: character.species, rowType: .species),
            .init(value: character.type, rowType: .type),
            .init(value: character.gender, rowType: .gender),
        ]
        
        delegate?.didSetData(character: character)
    }
}
