//
//  StarWarFilmRepositoryProtocol.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift

protocol StarWarFilmRepositoryProtocol {
    func fetchFilmDetails(havingId id: String) -> Observable<StarWarFilmModel>
}

protocol StarWarFilmDataSource {
    func fetchFilmDetails(havingId id: String) -> Observable<StarWarFilmModel>
}
