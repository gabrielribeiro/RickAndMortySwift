//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 05/10/23.
//

import UIKit

class CharacterDetailViewController: UITableViewController, CharacterDetailViewControllerDelegate {
    
    private let viewModel = CharacterDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
    }
    
    func configure(character: Character) {
        title = character.name
        
        viewModel.setData(for: character)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterIdentifier", for: indexPath)

        let row = viewModel.items[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        
        content.text = row.value
        content.secondaryText = row.rowType.title
        
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - CharacterDetailViewControllerDelegate
    
    func didSetData(character: Character) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
