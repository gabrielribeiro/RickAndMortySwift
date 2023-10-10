//
//  CharactersViewController.swift
//  RickAndMortyTest
//
//  Created by Gabriel Ribeiro on 05/10/23.
//

import UIKit
import SDWebImage

class CharactersViewController: UITableViewController, CharactersViewControllerDelegate {
    
    private let viewModel = CharactersViewModel()
    
    private var loadingAlertViewController: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Characters"
        
        self.clearsSelectionOnViewWillAppear = false
        
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetchData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = viewModel.characters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterViewCell", for: indexPath) as! CharacterViewCell
        
        cell.characterName?.text = character.name
        
        if let imageUrlString = character.image, let url = URL(string: imageUrlString) {
            cell.characterImageView?.sd_setImage(with: url)
        } else {
            cell.characterImageView?.image = UIImage(systemName: "person")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedCharacter = viewModel.characters[indexPath.row]
        
        self.performSegue(withIdentifier: "characterDetail", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "characterDetail",
              let controller = segue.destination as? CharacterDetailViewController,
              let selectedCharacter = viewModel.selectedCharacter else {
            return
        }
        
        controller.configure(character: selectedCharacter)
    }
    
    // MARK: - CharactersViewControllerDelegate
    
    func didFail(with error: Error?) {
        let alertViewController = UIAlertController(
            title: "Attention!",
            message: error?.localizedDescription ?? "An unexpected error occured.",
            preferredStyle: .alert
        )
        
        alertViewController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertViewController, animated: true)
        }
    }
    
    func didFetchWithSuccess() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func loadingDidChange(loading: Bool) {
        guard loading else {
            DispatchQueue.main.async {
                self.loadingAlertViewController?.dismiss(animated: false)
            }
            
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            
            let loadingAlertViewController = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();

            loadingAlertViewController.view.addSubview(loadingIndicator)
            
            strongSelf.present(loadingAlertViewController, animated: false, completion: nil)
            
            strongSelf.loadingAlertViewController = loadingAlertViewController
        }
    }
}
