//
//  AppDelegate.swift
//  LOC8
//
//  Created by Marwan Al Masri on 12/12/15.
//  Copyright © 2015 LOC8. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        var thetas: [Double] = []
//        var lambdas: [Double] = []
//        
//        var i = -360.0
//        
//        while i <= 360.0 {
//            thetas.append(i)
//            lambdas.append(i)
//            i += 45.0
//        }
//        
//        for lambda in lambdas {
//            let d_z = wrap(lambda / (Double.pi / 4)) % 4
//            for theta in thetas {
//                let d_xy = wrap(theta / (Double.pi / 4)) % 8
//                print("𝜆 = \(lambda) » \(d_z) \n𝜃 = \(theta) » \(d_xy)")
//                let direction = Direction(theta: theta.radian, lambda: lambda.radian)
//                print(direction)
//                print("__________________")
//            }
//            print("******************")
//            print("__________________")
//        }
        
        MultipeerManager.shared.isAdvertising = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: TabBarItemColor.Normal], for:UIControlState())
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: TabBarItemColor.Selected], for:.selected)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

