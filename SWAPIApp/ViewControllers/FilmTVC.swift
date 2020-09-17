//
//  FilmTVC.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 17/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit

class FilmTVC: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var wordCountFixedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.font = .mediumFont(with: 20)
        wordCountLabel.font = .mediumFont(with: 15)
        wordCountFixedLabel.font = .mediumFont(with: 15)
    }
    
    func configure(data: StarWarFilmModel) {
        titleLabel.text = data.title
        wordCountLabel.text = "\(data.openingCrawl.words.count)"
        wordCountFixedLabel.text = "Opening crawl word count"
    }
}
