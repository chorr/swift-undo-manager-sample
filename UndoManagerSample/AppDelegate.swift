//
//  AppDelegate.swift
//  UndoManagerSample
//
//  Created by Jeon Hyuncheol on 13/08/2019.
//  Copyright © 2019 chorr.net. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.applicationSupportsShakeToEdit = true
        return true
    }

}

