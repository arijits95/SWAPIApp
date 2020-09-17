//
//  StarWarCharacterDetailsViewModel.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class StarWarCharacterDetailsViewModel: ViewModelProtocol {
    
    //MARK: Properties
    var input: Input
    
    struct Input {
        let fetchCharacterDetails: AnyObserver<Void>
        let fetchFilmDetails: AnyObserver<Void>
        let backButtonTapped: AnyObserver<Void>
    }
    
    private let fetchCharacterDetailsSubject = PublishSubject<Void>()
    private let fetchFilmDetailsSubject = PublishSubject<Void>()
    private let backButtonTappedSubject = PublishSubject<Void>()
    
    let output: Output
    
    struct Output {
        let name: Driver<String>
        let birthYear: Driver<String>
        let height: Driver<String>
        let mass: Driver<String>
        let hairColor: Driver<String>
        let skinColor: Driver<String>
        let eyeColor: Driver<String>
        let gender: Driver<String>
        let filmCount: Driver<Int>
        let films: Observable<Array<StarWarFilmModel>>
        let showLoading: Driver<Bool>
    }
    
    private let disposebag = DisposeBag()
    private var characterDetailsSubject =  PublishSubject<StarWarCharacterModel>()
    private var filmDetailsSubject =  PublishSubject<Array<StarWarFilmModel>>()
    private var repository: StarWarFilmRepositoryProtocol!
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var characterDetails: StarWarCharacterModel!
    
    //MARK: Initializer
    init(characterDetails: StarWarCharacterModel, repository: StarWarFilmRepositoryProtocol) {
        
        self.repository = repository
        self.characterDetails = characterDetails
        
        // Prepare Input Interface
        // Exposing the Publish subjects as observers for the view controller to instruct the view model for what it needs
        input = Input(fetchCharacterDetails: fetchCharacterDetailsSubject.asObserver(),
                      fetchFilmDetails: fetchFilmDetailsSubject.asObserver(),
                      backButtonTapped: backButtonTappedSubject.asObserver())
        
        // Prepare Output Interface
        // Exposing the observables for the view controller to watch and use to drive its UI
        // View model will update these observables
        let name = characterDetailsSubject.map {
            print($0.name ?? "No value")
            return $0.name ?? "N/A"
        }.asDriver(onErrorJustReturn: "N/A")
        let birthYear = characterDetailsSubject.map { $0.birthYear ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let height = characterDetailsSubject.map { $0.height ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let mass = characterDetailsSubject.map { $0.mass ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let hairColor = characterDetailsSubject.map { $0.hairColor?.capitalized ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let skinColor = characterDetailsSubject.map { $0.skinColor?.capitalized ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let eyeColor = characterDetailsSubject.map { $0.eyeColor?.capitalized ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let gender = characterDetailsSubject.map { $0.gender?.capitalized ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let filmCount = characterDetailsSubject.map { $0.filmIds.count }.asDriver(onErrorJustReturn: 0)
        let films = filmDetailsSubject
        let showLoading = isLoading.asDriver()
        
        output = Output(name: name,
                      birthYear: birthYear,
                      height: height,
                      mass: mass,
                      hairColor: hairColor,
                      skinColor: skinColor,
                      eyeColor: eyeColor,
                      gender: gender,
                      filmCount: filmCount,
                      films: films,
                      showLoading: showLoading)
        
        
        // Subscribe to the Publish subjects by treating them as observable
        // React to the changes made by the view controller
        listenForInputs()
    }
    
    //MARK: Helper
    private func listenForInputs() {
        
        // Listen to when the view controller asks for character details and provide them
        fetchCharacterDetailsSubject.subscribe { _ in
            print("Acquiring Character details...")
            self.characterDetailsSubject.onNext(self.characterDetails)
        }.disposed(by: disposebag)
        
        // Listen to when the view controller asks for film details and provide them
        fetchFilmDetailsSubject.subscribe { _ in
            self.isLoading.accept(true)
            print("Acquiring Film details...")
            let observables = self.characterDetails.filmIds.map { self.repository.fetchFilmDetails(havingId: $0)
            }
            Observable.zip(observables)
                .materialize()
                .subscribe(onNext: { (event) in
                                switch event {
                                case .next(let films):
                                    self.filmDetailsSubject.onNext(films)
                                case .error(let error):
                                    print(error)
                                case .completed: break
                                }
                        }, onError: { (error) in
                                print(error)
                })
                .disposed(by: self.disposebag)
        }
        .disposed(by: disposebag)
    }
}

