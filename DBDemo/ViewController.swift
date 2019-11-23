//
//  ViewController.swift
//  DBDemo
//
//  Created by Stegowl05 on 29/03/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtFname: UITextField!
    
    @IBOutlet weak var txtLname: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createDB()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnGo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DeleteVC") as? DeleteVC
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSaveClick(_ sender: UIButton) {
        if txtFname.text?.count == 0 && (txtLname.text?.count)! == 0{
            print("Enter Proper data")
            return
        }
        else{
            var myName = txtFname.text!
            myName = myName.replacingOccurrences(of: "'", with: "\''")
            
            var myCity = txtLname.text!
            myCity = myCity.replacingOccurrences(of: "'", with: "\''")
            
            self.insertData(myName, myCity)
        }
    }
    func createDB() -> Void {
        let strURL = "CREATE TABLE IF NOT EXISTS DEMOSQL (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, CITY TEXT)"
        print(strURL)
        
        let data = AFSQLWrapper.createTable(strURL)
        print(data)
    }
    
    func insertData(_ myName: String, _ myCity: String) -> Void {
        let strURL = "INSERT INTO DEMOSQL (NAME, CITY) VALUES ('\(myName)', '\(myCity)')"
        print(strURL)
        
        let data = AFSQLWrapper.insertTable(strURL)
        print(data)
        if data.Status == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DeleteVC") as? DeleteVC
            self.navigationController!.pushViewController(vc!, animated: true)
        }
    }
}

