//
//  AFSQLWrapper.swift
//  DBDemo
//
//  Created by Stegowl05 on 29/03/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import Foundation
class AFSQLWrapper: NSObject {
    
    //Class For Create Table And Create Database
    class func createTable(_ strURL: String)  -> (Success: String, Failure: String) {
        var databasePath = String()
        let filemgr = FileManager.default
        var Success = String()
        var Failure = String()
        
        let dirPaths = filemgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        databasePath = dirPaths[0].appendingPathComponent("demoSql.db").path
        print(databasePath)
        Global.setDataPath(setDataPath: databasePath)
        //DataPath = "\(databasePath)"
        if !filemgr.fileExists(atPath: databasePath as String) {
            
            let contactDB = FMDatabase(path: databasePath as String)
            if contactDB == nil {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            }
            
            if (contactDB?.open())! {
                let sql_stmt = "\(strURL)"
                if !(contactDB?.executeStatements(sql_stmt))! {
                    print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                    Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
                }
                Success = "SuccessFully Created"
                contactDB?.close()
            } else {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            }
        }
        else{
            print("Database exists")
        }
        
        return (Success,Failure)
    }
    
    //Class For Insert Data into Table
    class func insertTable(_ strURL: String)  -> (Success: String, Failure: String, Status: Int) {
        var databasePath = String()
        var Success = String()
        var Failure = String()
        var Status = Int()
        databasePath = Global.getDataPath()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            
            let insertSQL = "\(strURL)"
            
            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            
            if !result! {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
                Status = 0
            } else {
                Success = "SuccessFully Insert"
                Status = 1
            }
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            Status = 0
        }
        
        
        return (Success,Failure,Status)
    }
    
    //Class For Select Data from table
    class func selectTable(_ strURL: String)  -> (arrData: NSMutableArray, Success: String, Failure: String, Status: Int) {
        
        let arrData = NSMutableArray()
        
        var databasePath = String()
        var Success = String()
        var Failure = String()
        var Status = Int()
        databasePath = Global.getDataPath()
        
        arrData.removeAllObjects()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            let querySQL = "\(strURL)"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                
                while (results?.next())! {
                    var dict : Dictionary = Dictionary<AnyHashable,Any>()
                    dict = (results?.resultDictionary())!
                    let data = dict as NSDictionary
                    arrData.add(data)
                    //arrData.add(results?.resultDictionary()! as! NSDictionary)
                }
                print(arrData)
                Status = 1
                Success = "Data Found"
                
            } else {
                print("Record not found")
                Status = 0
                Failure = "Record not found"
            }
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            Status = 0
        }
        
        return (arrData,Success,Failure,Status)
    }
    
    //Class For Select Data For Id from table
    class func selectIdDataTable(_ strURL: String)  -> (arrData: NSMutableArray, Success: String, Failure: String, Status: Int) {
        
        let arrData = NSMutableArray()
        
        var databasePath = String()
        var Success = String()
        var Failure = String()
        var Status = Int()
        databasePath = Global.getDataPath()
        
        arrData.removeAllObjects()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            let querySQL = "\(strURL)"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            if results?.next() == true {
                arrData.add(results?.resultDictionary() as! NSMutableDictionary)
                print(arrData)
                Status = 1
                Success = "Data Found"
                
            } else {
                print("Record not found")
                Status = 0
                Failure = "Record not found"
            }
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            Status = 0
        }
        return (arrData,Success,Failure,Status)
    }
    
    //Class For Update Data into Table
    class func updateTable(_ strURL: String)  -> (Success: String, Failure: String, Status: Int) {
        var databasePath = String()
        var Success = String()
        var Failure = String()
        var Status = Int()
        databasePath = Global.getDataPath()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            
            let queryUpdate = "\(strURL)"
            
            let result = contactDB?.executeUpdate(queryUpdate,
                                                  withArgumentsIn: nil)
                if !result! {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
                Status = 0
            } else {
                Success = "SuccessFully Updated"
                Status = 1
            }
            
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            Status = 0
        }
        return (Success,Failure,Status)
    }
    
    //Class For Delete Data For Id from table
    class func deleteDataTable(_ strURL: String)  -> (arrData: NSMutableArray, Success: String, Failure: String, Status: Int) {
        
        let arrData = NSMutableArray()
        
        var databasePath = String()
        var Success = String()
        var Failure = String()
        var Status = Int()
        databasePath = Global.getDataPath()
        
        arrData.removeAllObjects()
        let contactDB = FMDatabase(path: databasePath as String)
        
        if (contactDB?.open())! {
            let querySQL = "\(strURL)"
            
            let result = contactDB?.executeUpdate(querySQL,
                                                  withArgumentsIn: nil)
                if !result! {
                print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
                Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
                Status = 0
            } else {
                Success = "SuccessFully Deleted"
                Status = 1
            }
            contactDB?.close()
        } else {
            print("Error: \(String(describing: contactDB?.lastErrorMessage()))")
            Failure = "Error: \(String(describing: contactDB?.lastErrorMessage()))"
            Status = 0
        }
        return (arrData,Success,Failure,Status)
    }
}
