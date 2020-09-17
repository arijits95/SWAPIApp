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
        let refreshCharacters: AnyObserver<Void>
        let fetchCharactersMatchingString: AnyObserver<String>
        let selectedCharacterAtIndexSubject: AnyObserver<Int>
    }
    
    private let fetchCharactersSubject = PublishSubject<Void>()
    private let refreshCharactersSubject = PublishSubject<Void>()
    private let fetchCharactersMatchingStringSubject = BehaviorSubject<String>(value: "")
    private let selectedCharacterAtIndexSubject = PublishSubject<Int>()
    
    let output: Output
    
    struct Output {
        let characters: Observable<Array<StarWarCharacterViewFormattedModel>>
        let shouldMoveToCharacterDetailsView: BehaviorRelay<(Bool, StarWarCharacterModel?)>
        let showLoading: Driver<Bool>
        let showError: BehaviorRelay<String>
    }
    
    private var allCharactersSubject =  PublishSubject<Array<StarWarCharacterModel>>()
    private var shouldMoveToCharacterDetailsViewRelay =  BehaviorRelay<(Bool, StarWarCharacterModel?)>(value: (false, nil))
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var showErrorRelay = BehaviorRelay<String>(value: "")
    private var nextPageNumber = 1
    private var repository: StarWarCharacterRepositoryProtocol?
    private var isFetching = false
    private var allCharacters = [StarWarCharacterModel]()
    
    init(repository: StarWarCharacterRepositoryProtocol) {
        
        self.repository = repository
        
        // Prepare Input Interface
        // Exposing the Publish subjects as observers for the view controller to instruct the view model for what it needs
        input = Input(fetchCharacters: fetchCharactersSubject.asObserver(),
                      refreshCharacters: refreshCharactersSubject.asObserver(),
                      fetchCharactersMatchingString: fetchCharactersMatchingStringSubject.asObserver(),
                      selectedCharacterAtIndexSubject: selectedCharacterAtIndexSubject.asObserver())
        
        // Prepare Output Interface
        // Exposing the observables for the view controller to watch and use to drive its UI
        // View model will update these observables
        let characters = allCharactersSubject
            .map { (list) -> Array<StarWarCharacterViewFormattedModel> in
                list.map {  StarWarCharacterViewFormattedModel(name: $0.name,
                                                               birthYear: $0.birthYear?.capitalized ?? "N/A",
                                                               gender: $0.gender?.capitalized ?? "N/A",
                                                               filmCount: $0.filmIds.count) }
            }
        
        let shouldMoveToCharacterDetailsView = shouldMoveToCharacterDetailsViewRelay
        let showLoading = isLoading.asDriver()
        let showError = showErrorRelay
        
        output = Output(characters: characters,
                        shouldMoveToCharacterDetailsView: shouldMoveToCharacterDetailsView,
                        showLoading: showLoading,
                        showError: showError)
        
        
        
        // Subscribe to the Publish subjects by treating them as observable
        // React to the changes made by the view controller
        listenForInputs()
    }
    
    private func listenForInputs() {
        
        // Listen for fetch characters action
        fetchCharactersSubject.subscribe { _ in
            if self.isFetching {
                return
            }
            self.isFetching = true
            if self.nextPageNumber == 1 {
                self.allCharacters.removeAll()
                self.allCharactersSubject.onNext(self.allCharacters)
                self.isLoading.accept(true)
            }
            print("Fetching page: \(self.nextPageNumber)")
            if self.nextPageNumber > 0 {
                self.repository?.fetchCharacters(onPage: self.nextPageNumber)
                    .subscribe(onNext: { (characterListModel) in
                                    self.isFetching = false
                                    self.isLoading.accept(false)
                                    self.allCharacters += characterListModel.characters
                                    self.nextPageNumber = characterListModel.nextPageNumber ?? -1
                                    self.allCharactersSubject.onNext(self.allCharacters)
                               },
                               onError: { (error) in
                                    self.isFetching = false
                                    self.isLoading.accept(false)
                                    if self.nextPageNumber == 1 {
                                        print("Error while fetching first page....")
                                        if let description = error.asAFError?.errorDescription {
                                            self.showErrorRelay.accept(description)
                                        } else if let description = error.asStarWarError?.errorDescription  {
                                            self.showErrorRelay.accept(description)
                                        } else {
                                            self.showErrorRelay.accept(StarWarError.unknown.errorDescription)
                                        }
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
        
        // Listen for character selection action
        selectedCharacterAtIndexSubject.subscribe { event in
            switch event {
            case .next(let index):
                self.shouldMoveToCharacterDetailsViewRelay.accept((true, self.allCharacters[index]))
            default: break
            }
        }
        .disposed(by: disposebag)
        
        // Listen for refresh action
        refreshCharactersSubject.subscribe { _ in
            self.nextPageNumber = 1
            self.fetchCharactersSubject.onNext(())
        }.disposed(by: disposebag)
    }
}
