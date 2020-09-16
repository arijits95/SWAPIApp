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
    
    let disposebag = DisposeBag()
    let input: Input
    
    struct Input {
        let fetchFilmDetails: AnyObserver<Void>
        let backButtonTapped: AnyObserver<Void>
    }
    
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
        let films: Observable<Array<StarWarFilmModel>>
        let showLoading: Driver<Bool>
    }
    
    private var characterDetailsSubject =  PublishSubject<StarWarCharacterModel>()
    private var filmDetailsSubject =  PublishSubject<Array<StarWarFilmModel>>()
    private var repository: StarWarFilmRepositoryProtocol!
    private var isLoading = BehaviorRelay<Bool>(value: false)
    private var characterDetails: StarWarCharacterModel!
    
    init(characterDetails: StarWarCharacterModel, repository: StarWarFilmRepositoryProtocol) {
        
        self.repository = repository
        self.characterDetails = characterDetails
        
        input = Input(fetchFilmDetails: fetchFilmDetailsSubject.asObserver(),
                      backButtonTapped: backButtonTappedSubject.asObserver())
        
        let name = characterDetailsSubject.map { $0.name ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let birthYear = characterDetailsSubject.map { $0.birthYear ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let height = characterDetailsSubject.map { $0.height ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let mass = characterDetailsSubject.map { $0.mass ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let hairColor = characterDetailsSubject.map { $0.hairColor ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let skinColor = characterDetailsSubject.map { $0.skinColor ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let eyeColor = characterDetailsSubject.map { $0.eyeColor ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
        let gender = characterDetailsSubject.map { $0.gender ?? "N/A" }.asDriver(onErrorJustReturn: "N/A")
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
                        films: films,
                        showLoading: showLoading)
        
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
                                    films.forEach { debugPrint($0.title!) }
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
