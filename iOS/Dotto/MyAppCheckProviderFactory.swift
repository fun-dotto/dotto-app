//
//  MyAppCheckProviderFactory.swift
//  Dotto
//
//  Created by Kanta Oikawa on 2026/04/11.
//

import FirebaseAppCheck
import FirebaseCore

final class MyAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        return AppAttestProvider(app: app)
    }
}
