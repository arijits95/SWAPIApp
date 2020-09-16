//
//  StarWarCharacterDetailsViewController.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class StarWarCharacterDetailsViewController: UIViewController {
    
    var viewModel: StarWarCharacterDetailsViewModel!
    var details: StarWarCharacterModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func addBackButton() {
        
    }
    
    func bindViewModel() {
        
        viewModel = StarWarCharacterDetailsViewModel(characterDetails: details,
                                                     repository: StarWarFilmDataRepository(remoteDataSource: StarWarFilmRemoteDataSource()))
        
        viewModel.input.fetchFilmDetails.onNext(())
    }
}
