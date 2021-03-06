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

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // init and share itemStore object with itemsViewController
        
        let itemsViewController = window!.rootViewController as! ItemsViewController
        
        let itemStore = ItemStore() // new al objects still
        //itemsViewController.itemStore = itemStore
        
        // silver challenge
        var itemsUnderEqual50 = [Item]()
        var itemsOver50 = [Item]()
        for item in itemStore.allItems {
            if item.valueInDollars <= 50 {
                itemsUnderEqual50.append(item)
            } else {
                itemsOver50.append(item)
            }
        }
        
        var sectionArray = [ItemSectionStore]()
        sectionArray.append(ItemSectionStore(headerName: "Under or Equal to $50", itemStores: itemsUnderEqual50))
        sectionArray.append(ItemSectionStore(headerName: "Over $50", itemStores: itemsOver50))
        itemsViewController.itemSections = sectionArray
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

