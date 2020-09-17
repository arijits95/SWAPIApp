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

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let starWarCharacterListViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "StarWarCharacterListViewController") as! StarWarCharacterListViewController
        let viewModel = StarWarCharacterListViewModel(repository: StarWarCharacterDataRepository(remoteDataSource: StarWarCharacterRemoteDataSource()))
        starWarCharacterListViewController.viewModel = viewModel
        let navVC = UINavigationController(rootViewController: starWarCharacterListViewController)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

