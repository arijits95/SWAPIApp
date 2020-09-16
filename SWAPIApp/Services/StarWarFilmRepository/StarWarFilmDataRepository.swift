//
//  StarWarFilmDataRepository.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift

class StarWarFilmDataRepository: StarWarFilmRepositoryProtocol {
    
    private let remoteDataSource: StarWarFilmDataSource!
    
    init(remoteDataSource: StarWarFilmDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchFilmDetails(havingId id: String) -> Observable<StarWarFilmModel> {
        return remoteDataSource.fetchFilmDetails(havingId: id)
    }

}

