//
//  CharacterTVC.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 17/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit

class CharacterTVC: UITableViewCell {
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var filmCountLabel: UILabel!
    @IBOutlet weak var filmFixedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        wrapperView.layer.cornerRadius = 20
        wrapperView.clipsToBounds = true
        nameLabel.font = .mediumFont(with: 20)
        birthYearLabel.font = .mediumFont(with: 15)
        genderLabel.font = .mediumFont(with: 15)
        filmCountLabel.font = .boldFont(with: 60)
        filmFixedLabel.font = .boldFont(with: 13)
        filmFixedLabel.textColor = .lightGray
        let clearView = UIView()
        clearView.backgroundColor = .clear
        backgroundView = clearView
    }
    
    func configure(data: StarWarCharacterViewFormattedModel) {
        nameLabel.text = data.name
        birthYearLabel.text = data.birthYear
        genderLabel.text = data.gender
        filmCountLabel.text = "\(data.filmCount)"
        filmFixedLabel.text = "Films"
    }
}
