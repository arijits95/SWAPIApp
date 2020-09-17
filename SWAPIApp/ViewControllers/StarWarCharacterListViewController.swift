//
//  StarWarCharacterListViewController.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class StarWarCharacterListViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var characterTableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    //MARK: Properties
    var refreshButton: UIBarButtonItem!
    let disposeBag = DisposeBag()
    var viewModel: StarWarCharacterListViewModel!
    private var lastIndex = 0
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    //MARK: Helper methods
    
    // Method to do initial setup
    private func initialSetup() {
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
        navigationItem.rightBarButtonItem = refreshButton
        bindViewModel()
        fetchCharacterList()
    }
    
    // Method to setup UI
    private func setupUI() {
        title = "Star Wars Character List"
        statusLabel.font = .mediumFont(with: 20)
        statusLabel.textColor = .lightGray
        navigationController?.navigationBar.barTintColor = .white
        setupTableView()
    }
    
    // Method to bind UI to View Model
    private func setupTableView() {
        characterTableView.delegate = self
        characterTableView.separatorStyle = .none
    }
    
    // Method to bind UI to View Model
    private func bindViewModel() {
        
        refreshButton.rx.tap.subscribe { (event) in
            switch event {
            case .next(_): self.viewModel.input.refreshCharacters.onNext(())
            default: break
            }
        }.disposed(by: disposeBag)
        
        // Bind to table view
        viewModel.output.characters.bind(to:
            self.characterTableView.rx.items(cellIdentifier: "CharacterTVC",
                                    cellType: CharacterTVC.self)) {
                                        row, character, cell in
                                        
                                        cell.configure(data: character)
                                                                        
        }.disposed(by: disposeBag)
        
//        viewModel.output.characters.subscribe(onNext: { list in
//            self.lastIndex = list.count
//        }).disposed(by: disposeBag)
        
        // Navigate to details page when instructed by view model
        viewModel.output.shouldMoveToCharacterDetailsView.subscribe(onNext: { (shouldNavigate, details) in
            if shouldNavigate && details != nil {
                let detailsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "StarWarCharacterDetailsViewController") as! StarWarCharacterDetailsViewController
                detailsVC.details = details
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
            }).disposed(by: disposeBag)
        
        loader.hidesWhenStopped = true
        viewModel.output.showLoading.drive(loader.rx.isAnimating).disposed(by: disposeBag)
        viewModel.output.showError.subscribe { (event) in
            switch event {
            case .next(let string):
                if !string.isEmpty {
                    self.statusLabel.text = "No Data Found"
                    self.statusLabel.isHidden = false
                    self.showAlert(withMessage: string)
                } else {
                    self.statusLabel.text = ""
                    self.statusLabel.isHidden = true
                }
            default: break
            }
        }.disposed(by: disposeBag)
    }
    
    // Method to tell View Model to fetch character list
    private func fetchCharacterList() {
        viewModel.input.fetchCharacters.onNext(())
    }
    
    // Method to show alert
    private func showAlert(withMessage message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}

//MARK: UITableViewDelegate
extension StarWarCharacterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Character selected at Index: \(indexPath.row)")
        viewModel.input.selectedCharacterAtIndexSubject.onNext(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            debugPrint("End of Table View reached....")
            viewModel.input.fetchCharacters.onNext(())
        }
    }
}
