//
//  StarWarCharacterRepositoryProtocol.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift

protocol StarWarCharacterRepositoryProtocol {
    func fetchCharacters(onPage page: Int) -> Observable<StarWarCharacterListModel>
}

protocol StarWarCharacterDataSource {
    func fetchCharacters(onPage page: Int) -> Observable<StarWarCharacterListModel>
}
