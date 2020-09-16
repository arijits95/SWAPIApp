//
//  StarWarCharacterRemoteDataSource.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 16/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper

class StarWarCharacterRemoteDataSource: StarWarCharacterDataSource {
    
    func fetchCharacters(onPage page: Int) -> Observable<StarWarCharacterListModel> {
        
        return Observable<StarWarCharacterListModel>.create { (observer) -> Disposable in
            
            let apiEndPoint = StarWarAPIEndPoint.characters(pageNumber: page)
            
            let request = AF.request(apiEndPoint.url,
                       method: apiEndPoint.method,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: nil,
                       interceptor: nil,
                       requestModifier: { $0.timeoutInterval = 20 })
                        
            request.responseJSON { (response) in
                
                    switch response.result {
                    case .success(let result):
                        guard let statusCode = response.response?.statusCode else { return }
                        switch statusCode {
                        case 200:
                            
                            guard let characterListModel = Mapper<StarWarCharacterListModel>().map(JSONObject: result) else {
                                
                                observer.onError(StarWarError.invalidResponseFromServer)
                                return
                            }
                            
                            observer.onNext(characterListModel)
                            observer.onCompleted()
                            
                        default:
                            
                            observer.onError(StarWarError.unknown)
                        }
                    case .failure(let error):
                        
                        observer.onError(error)
                    }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
}




