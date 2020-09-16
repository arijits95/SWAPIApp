//
//  StarWarCharacterListViewModel.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol StarWarCharacterListViewDelegate {
    func moveToCharacterDetailsView(_ details: StarWarCharacterModel)
    func showError(title: String, description: String)
}

protocol ViewModelProtocol: class {
    associatedtype Input
    associatedtype Output
    var input: Input { get }
    var output: Output { get }
}

struct StarWarCharacterViewFormattedModel {
    var name: String
    var birthYear: String
    var gender: String
    var filmCount: Int
}

class StarWarCharacterListViewModel: ViewModelProtocol {
    
    let disposebag = DisposeBag()
    let input: Input
    
    struct Input {
        let fetchCharacters: AnyObserver<Void>
        let fetchCharactersMatchingString: AnyObserver<String>
        let selectedCharacterAtIndexSubject: AnyObserver<Int>
    }
    
    private let fetchCharactersSubject = PublishSubject<Void>()
    private let fetchCharactersMatchingStringSubject = BehaviorSubject<String>(value: "")
    private let selectedCharacterAtIndexSubject = PublishSubject<Int>()
    
    let output: Output
    
    struct Output {
        let characters: Observable<Array<StarWarCharacterViewFormattedModel>>
        let shouldMoveToCharacterDetailsView: BehaviorRelay<(Bool, StarWarCharacterModel?)>
    }
    
    private var allCharactersSubject =  PublishSubject<Array<StarWarCharacterModel>>()
    private var shouldMoveToCharacterDetailsViewRelay =  BehaviorRelay<(Bool, StarWarCharacterModel?)>(value: (false, nil))
    private var nextPageNumber = 1
    private var repository: StarWarCharacterRepositoryProtocol?
    private var isFetching = false
    private var allCharacters = [StarWarCharacterModel]()
    
    init(repository: StarWarCharacterRepositoryProtocol) {
        
        self.repository = repository
        
        input = Input(fetchCharacters: fetchCharactersSubject.asObserver(),
                      fetchCharactersMatchingString: fetchCharactersMatchingStringSubject.asObserver(),
                      selectedCharacterAtIndexSubject: selectedCharacterAtIndexSubject.asObserver())
        
        let characters = allCharactersSubject
            .map { (list) -> Array<StarWarCharacterViewFormattedModel> in
                list.map {  StarWarCharacterViewFormattedModel(name: $0.name,
                                                               birthYear: $0.birthYear ?? "N/A",
                                                               gender: $0.gender ?? "N/A",
                                                               filmCount: $0.filmIds.count) }
            }
//           .asDriver(onErrorJustReturn: [])
        
        let shouldMoveToCharacterDetailsView = shouldMoveToCharacterDetailsViewRelay
        
        output = Output(characters: characters,
                        shouldMoveToCharacterDetailsView: shouldMoveToCharacterDetailsView)
        
        fetchCharactersSubject.subscribe { _ in
            if self.isFetching {
                return
            }
            self.isFetching = true
            print("Fetching page: \(self.nextPageNumber)")
            if self.nextPageNumber > 0 {
                self.repository?.fetchCharacters(onPage: self.nextPageNumber)
                    .subscribe(onNext: { (characterListModel) in
                                    self.isFetching = false
                                    self.allCharacters += characterListModel.characters
                                    self.nextPageNumber = characterListModel.nextPageNumber ?? -1
                                    self.allCharactersSubject.onNext(self.allCharacters)
                               },
                               onError: { (error) in
                                    self.isFetching = false
                                    if self.nextPageNumber == 1 {
                                        print("Error while fetching first page....")
                                    } else {
                                        print("Error while fetching page \(self.nextPageNumber)")
                                    }
                                    print(error)
                               })
                               .disposed(by: self.disposebag)
            } else {
                print("No more pages left to fetch")
            }
        }
        .disposed(by: disposebag)
        
        selectedCharacterAtIndexSubject.subscribe { event in
            switch event {
            case .next(let index):
                self.shouldMoveToCharacterDetailsViewRelay.accept((true, self.allCharacters[index]))
            default: break
            }
        }
        .disposed(by: disposebag)
    }
}
