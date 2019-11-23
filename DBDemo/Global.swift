//
//  Global.swift
//  DBDemo
//
//  Created by Stegowl05 on 29/03/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation

class Global: NSObject
{
    static let sharedInstance = Global()
    
    // Variable Declaration
    var userDataPath = String()
    
    class func setDataPath(setDataPath : String) -> Void {
        sharedInstance.userDataPath = setDataPath as String
    }
    class func getDataPath() -> String {
        return sharedInstance.userDataPath as String
    }
    
    
}
