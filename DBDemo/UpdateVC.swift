//
//  UpdateVC.swift
//  DBDemo
//
//  Created by Stegowl05 on 29/03/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

class UpdateVC: UIViewController {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLname: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    var globalId = Int()
    var arrLocalData = NSMutableArray()
    var databasePath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnGo(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnUpdateClick(_ sender: UIButton) {
        self.updateData()
    }
    
    func showDataUpdate() {
        let strURL = "SELECT * FROM DEMOSQL where ID='\(globalId)'"
        print(strURL)
        
        let data = AFSQLWrapper.selectIdDataTable(strURL)
        print(data)
        if data.Status == 1 {
            arrLocalData = data.arrData
            txtName.text = (arrLocalData.object(at: 0) as AnyObject).value(forKey: "NAME") as? String
            
            txtName.text = (arrLocalData.object(at: 0) as AnyObject).value(forKey: "CITY") as? String
        }
        
    }
    
    func updateData(){
        
        let strURL = "update DEMOSQL set NAME='\(txtName.text!)', CITY='\(txtLname.text!)' where ID='\(globalId)'"
        print(strURL)
        
        let data = AFSQLWrapper.updateTable(strURL)
        print(data)
        if data.Status == 1 {
            txtName.text = ""
            txtLname.text = ""
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as? ViewController
            self.navigationController!.pushViewController(vc!, animated: true)
        }
    }
}
