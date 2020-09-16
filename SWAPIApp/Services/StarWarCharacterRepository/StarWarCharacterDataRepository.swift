//
//  StarWarCharacterDataRepository.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift

class StarWarCharacterDataRepository: StarWarCharacterRepositoryProtocol {
    
    private let remoteDataSource: StarWarCharacterDataSource!
    
    init(remoteDataSource: StarWarCharacterDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchCharacters(onPage page: Int) -> Observable<StarWarCharacterListModel> {
        return remoteDataSource.fetchCharacters(onPage: page)
    }

}
