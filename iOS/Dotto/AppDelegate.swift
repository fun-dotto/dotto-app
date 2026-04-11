//
//  AppDelegate.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import FirebaseAppCheck
import FirebaseCore
import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // AppCheck
        let providerFactory: AppCheckProviderFactory
#if DEBUG
        providerFactory = AppCheckDebugProviderFactory()
#else
        providerFactory = MyAppCheckProviderFactory()
#endif
        AppCheck.setAppCheckProviderFactory(providerFactory)

        FirebaseApp.configure()

        return true
    }
}
