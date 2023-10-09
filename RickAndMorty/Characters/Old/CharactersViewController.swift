//
//  CharactersViewController.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 26/09/23.
//

import UIKit

class CharactersViewController: UITableViewController, CharactersViewControllerDelegate {
    
    private let viewModel = CharactersViewModel()
    
    private var loadingAlertViewController: UIAlertController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.fetch()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewModel.characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let character = viewModel.characters[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = character.name
        content.secondaryText = character.species ?? "Unknown"
    
        cell.contentConfiguration = content

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK - CharactersViewControllerDelegate
    
    func didFetchWithSuccess() {
        debugPrint("Success")
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didFailFetching(with error: Error?) {
        debugPrint("Fail", error)
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(
                title: "Attention",
                message: error?.localizedDescription ?? "An unexpected error occured",
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alertController, animated: true)
        }
    }
    
    func loadingStateDidChange(loading: Bool) {
        debugPrint("Loading", loading)
        
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            viewModel.fetch()
        }
    }
}
