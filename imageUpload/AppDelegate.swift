//
//  AppDelegate.swift
//  imageUpload
//
//  Created by Philip Chau on 9/3/2022.
//

import UIKit
import Firebase
import PayPalCheckout
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let config = CheckoutConfig(
                clientID: "AWq3P5hVAxiQ76DIJzMoG7TwF5gV-VoOMgPQ3m7ymLgzdb6C8mRv6td3I4k3EKrPeakLmdcXcDcJVYC8",
                //make sure the return url is in lowercase
                returnUrl: "philip.imageupload://paypalpay",
                environment: .sandbox
//                clientID: "ASKI-6_GIMUgF05CvCeESVs2wRnnNm0b17whgZGIGVnUAkgMh4MBK2Z6fMDPuh8ktPQ37C-xI_AyKKKe",
//                //make sure the return url is in lowercase
//                returnUrl: "com.onurcansever.saffycleaning://paypalpay",
//                environment: .sandbox
            )
        Checkout.set(config: config)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

