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

class CharacterTVC: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthYear: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var filmCount: UILabel!
    
    func configure(data: StarWarCharacterViewFormattedModel) {
        name.text = data.name
        birthYear.text = data.birthYear
        gender.text = data.gender
        filmCount.text = "\(data.filmCount)"
    }
}

class StarWarCharacterListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: StarWarCharacterListViewModel!
    private var lastIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        viewModel = StarWarCharacterListViewModel(repository: StarWarCharacterDataRepository(remoteDataSource: StarWarCharacterRemoteDataSource()))
        
        
        viewModel.output.characters.bind(to:
            self.tableView.rx.items(cellIdentifier: "CharacterTVC",
                                    cellType: CharacterTVC.self)) {
                                        row, character, cell in
                                        
                                        cell.configure(data: character)
                                                                        
        }.disposed(by: disposeBag)
        
        viewModel.output.characters.subscribe(onNext: { list in
            self.lastIndex = list.count
        }).disposed(by: disposeBag)
        
        viewModel.output.shouldMoveToCharacterDetailsView.subscribe(onNext: { (shouldNavigate, details) in
            if shouldNavigate && details != nil {
                let detailsVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "StarWarCharacterDetailsViewController") as! StarWarCharacterDetailsViewController
                detailsVC.details = details
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
            }).disposed(by: disposeBag)
        
        viewModel.input.fetchCharacters.onNext(())
        
    }
    
}

extension StarWarCharacterListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        debugPrint("Character selected at Index: \(indexPath.row)")
        viewModel.input.selectedCharacterAtIndexSubject.onNext(indexPath.row)
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

extension StarWarCharacterListViewController: StarWarCharacterListViewDelegate {
    
    func moveToCharacterDetailsView(_ details: StarWarCharacterModel) {
        
    }
    
    func showError(title: String, description: String) {
        
    }

}
