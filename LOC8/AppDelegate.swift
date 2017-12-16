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
        
//        /*
//         𝜃 ∈ [0, +π] rad ([0° ≤ 𝜃 ≤ 180°])
//         𝛷 ∈ [-π, +π] rad ([-180° ≤ 𝛷 < 180°]
//         */
//        
//        var thetas: [Double] = []
//        var phis: [Double] = []
//        
//        var i = -180.0
//        
//        while i <= 180.0 {
//            if i >= 0 {
//                thetas.append(i)
//            }
//            phis.append(i)
//            i += 45.0
//        }
//
//        for theta in thetas {
//            for phi in phis {
//                print("𝛷 = \(phi) AND 𝜃 = \(theta)")
//                let direction = Direction(theta: theta.radian, phi: phi.radian)
//                print(direction)
//                print("__________________")
//            }
//            print("******************")
//            print("__________________")
//        }
        
//        let vector = Vector3D(x: 1, y: 1, z: -1)
//        print(vector)
//        print("cartesian to spherical\t\t \(vector.cartesianVector.sphericalVector)")
//        print("spherical to cartesian\t\t \(vector.sphericalVector.cartesianVector)\n")
//        print("cartesian to cylindrical\t \(vector.cartesianVector.cylindricalVector)")
//        print("cylindrical to cartesian\t \(vector.cylindricalVector.cartesianVector)\n")
//        print("spherical to cylindrical\t \(vector.sphericalVector.cylindricalVector)")
//        print("cylindrical to spherical\t \(vector.cylindricalVector.sphericalVector)\n")
        
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

