//
//  AppDelegate.swift
//  Homepwner
//
//  Created by James Birchall on 29/10/2016.
//  Copyright © 2016 James Birchall. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let itemStore = ItemStore() // move here to be usable in AppDelegate functions

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(Bundle.main.bundlePath)
        
        print(#function)
        
        // init and share itemStore object with itemsViewController
        //let itemStore = ItemStore()
        
        let imageStore = ImageStore()
        //let itemsViewController = window!.rootViewController as! ItemsViewController
        // Using UINavigationController now so need to reflect root
        let navigationController = window?.rootViewController as! UINavigationController
        let itemsViewController = navigationController.topViewController as! ItemsViewController
        itemsViewController.itemStore = itemStore
        itemsViewController.imageStore = imageStore
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(#function)
        
        // save our items here!
        let success = itemStore.saveChanges()
        if success {
            print("Item successfully saved.")
        } else {
            print("Items not saved properly.")
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(#function)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print(#function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print(#function)
    }


}

