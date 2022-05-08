//
//  Configuration.swift
//  firebaseEmulatorProject
//
//  Created by Akiya Ozawa on R 3/08/28.
//

import Foundation
import Firebase

class Configuration {
    
    static let shared = Configuration()
  
    func auth() -> Auth {
        #if DEBUG
        let auth = Auth.auth()
        auth.useEmulator(withHost: "localhost", port: 9099)
        return auth
        #else
        return auth
        #endif
    }
    
    func FirestoreSettings() -> FirestoreSettings {
        
        let settings = Firestore.firestore().settings
        #if DEBUG
        settings.host = "localhost:8080"
        settings.isPersistenceEnabled = false
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        return settings
        #else
        //default setting
        return settings
        #endif
    }
}
