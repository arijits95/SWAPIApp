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
    
    //MARK: IBOutlets
    @IBOutlet weak var topWrapperView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthYearLabel: UILabel!
    @IBOutlet weak var physicalAttributesWrapperView: UIView!
    @IBOutlet weak var physicalAttributesFixedLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var heightFixedLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var massFixedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var genderFixedLabel: UILabel!
    @IBOutlet weak var hairColorLabel: UILabel!
    @IBOutlet weak var hairColorFixedLabel: UILabel!
    @IBOutlet weak var skinColorLabel: UILabel!
    @IBOutlet weak var skinColorFixedLabel: UILabel!
    @IBOutlet weak var eyeColorLabel: UILabel!
    @IBOutlet weak var eyeColorFixedLabel: UILabel!
    @IBOutlet weak var filmsWrapperView: UIView!
    @IBOutlet weak var filmsFixedLabel: UILabel!
    @IBOutlet weak var filmsTableView: UITableView!
    @IBOutlet weak var filmsTableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    var viewModel: StarWarCharacterDetailsViewModel!
    var details: StarWarCharacterModel!
    let cellHeight = CGFloat(70)
    let disposeBag = DisposeBag()
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        UIView.animate(withDuration: 0.3) {
            self.filmsWrapperView.layoutIfNeeded()
        }
    }
    
    //MARK: Helper methods
    // Method to do initial setup
    private func initialSetup() {
        bindViewModel()
        fetchCharacterDetails()
        fetchFilmDetails()
    }
    
    // Method to setup UI
    private func setupUI() {
        
        title = "Details"
        heightFixedLabel.text = "Height"
        massFixedLabel.text = "Mass"
        genderFixedLabel.text = "Gender"
        hairColorFixedLabel.text = "Hair"
        skinColorFixedLabel.text = "Skin"
        eyeColorFixedLabel.text = "Eye"
        
        [topWrapperView, physicalAttributesWrapperView, filmsWrapperView].forEach {
            $0?.layer.cornerRadius = 20
            $0?.clipsToBounds = true
        }
        
        nameLabel.font = .mediumFont(with: 30)
        birthYearLabel.font = .mediumFont(with: 20)
        
        [physicalAttributesFixedLabel, filmsFixedLabel].forEach {
            $0?.font = .mediumFont(with: 25)
        }
        
        [heightLabel, massLabel, genderLabel, hairColorLabel, skinColorLabel, eyeColorLabel].forEach {
            $0?.font = .boldFont(with: 15)
        }
        
        [heightFixedLabel, massFixedLabel, genderFixedLabel, hairColorFixedLabel, skinColorFixedLabel, eyeColorFixedLabel].forEach {
            $0?.font = .boldFont(with: 20)
            $0?.textColor = .lightGray
        }
        
        setupTableView()
    }
    
    private func setupTableView() {
        filmsTableView.delegate = self
        filmsTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: filmsTableView.bounds.width, height: 1))
        filmsTableView.tableFooterView = view
    }
    
    private func addBackButton() {
        
    }
    
    // Method to bind UI to View Model
    private func bindViewModel() {
        
        viewModel = StarWarCharacterDetailsViewModel(characterDetails: details,
                                                     repository: StarWarFilmDataRepository(remoteDataSource: StarWarFilmRemoteDataSource()))
        
        viewModel.output.name.drive(nameLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.birthYear.drive(birthYearLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.height.drive(heightLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.mass.drive(massLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.gender.drive(genderLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.hairColor.drive(hairColorLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.skinColor.drive(skinColorLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.eyeColor.drive(eyeColorLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.filmCount.map({ CGFloat($0) * self.cellHeight })
            .drive(filmsTableViewHeightConstraint.rx.constant).disposed(by: disposeBag)
        viewModel.output.films.bind(to:
            self.filmsTableView.rx.items(cellIdentifier: "FilmTVC",
                                    cellType: FilmTVC.self)) {
                                        row, film, cell in
                                        
                                        cell.configure(data: film)
                                                                        
        }.disposed(by: disposeBag)
    }
    
    // Method to tell View Model to fetch character details
    private func fetchCharacterDetails() {
        viewModel.input.fetchCharacterDetails.onNext(())
    }
    
    // Method to tell View Model to fetch film details
    private func fetchFilmDetails() {
        viewModel.input.fetchFilmDetails.onNext(())
    }
    
}

extension StarWarCharacterDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
