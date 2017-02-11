//
//  DatabaseManager.swift
//  dinner517
//
//  Created by sheldon on 16/7/29.
//  Copyright © 2016年 anglesoft. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseManager {
    
    // Please reset the new schema version. This must be greater than the previously used
    // version (if you've never set a schema version before, the version is 0).
    static let currentVersion: UInt64 = 5
    
    /// **MUST** call this method inside `application(application:didFinishLaunchingWithOptions:)`.
    /// The initial version is 0.
    class func migrate() {
        
        let config = Realm.Configuration(
            schemaVersion: currentVersion,
            migrationBlock: { migration, oldSchemaVersion in
            
                if oldSchemaVersion < currentVersion {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
}
