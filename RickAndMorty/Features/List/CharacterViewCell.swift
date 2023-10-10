//
//  CharacterViewCell.swift
//  RickAndMorty
//
//  Created by Gabriel Ribeiro on 05/10/23.
//

import UIKit

class CharacterViewCell: UITableViewCell {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
