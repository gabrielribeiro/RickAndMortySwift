//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 05/10/23.
//

import UIKit

class CharacterDetailViewController: UITableViewController {
    
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

    var selectedCharacter: Character? {
        didSet {
            guard let selectedCharacter = selectedCharacter else { return }
            
            self.configure(character: selectedCharacter)
        }
    }
    
    private var rows: [Row] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    func configure(character: Character) {
        self.title = character.name
        
        self.rows = [
            .init(value: character.name, rowType: .name),
            .init(value: character.status ?? "null", rowType: .status),
            .init(value: character.species ?? "null", rowType: .species),
            .init(value: character.type ?? "null", rowType: .type),
            .init(value: character.gender ?? "null", rowType: .gender),
        ]
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterIdentifier", for: indexPath)

        let row = rows[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = row.value
        content.secondaryText = row.rowType.title
        
        cell.contentConfiguration = content

        return cell
    }
}
