//
//  AppDelegate.swift
//  SWAPIApp
//
//  Created by Arijit Sarkar on 15/09/20.
//  Copyright © 2020 Arijit Sarkar. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var dataSource = StarWarCharacterRemoteDataSource()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        dataSource
//            .fetchCharacters(onPage: 0)
//            .subscribe(onNext: { (model) in
//            print(model.characters.count)
//        }, onError: { (error) in
//            print(error)
//        }, onCompleted: {
//            print("Completed")
//        }) {
//            print("Disposed")
//        }
//        .disposed(by: disposeBag)
        
        return true
    }

}

