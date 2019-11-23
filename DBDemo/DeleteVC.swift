//
//  DeleteVC.swift
//  DBDemo
//
//  Created by Stegowl05 on 29/03/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit

class tblCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
}
class DeleteVC: UIViewController, UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var tblDelete: UITableView!
    var globalID = 0
    var arrLocalData = NSMutableArray()
    var dictData = NSMutableDictionary()
    var databasePath = String()
    var ID = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func showData() {
        let strURL = "SELECT * FROM DEMOSQL"
        print(strURL)
        arrLocalData.removeAllObjects()
        let data = AFSQLWrapper.selectTable(strURL)
        print(data)
        if data.Status == 1 {
            arrLocalData = data.arrData
            tblDelete.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return arrLocalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell") as! tblCell
        cell.lblName.text = (arrLocalData.object(at: indexPath.row) as AnyObject).value(forKey: "NAME") as? String
        cell.btnDelete.addTarget(self, action: #selector(btnDelete), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        globalID = ((arrLocalData.object(at: indexPath.row) as! NSObject).value(forKey: "ID") as? Int)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateVC") as? UpdateVC
        vc!.globalId = globalID
        self.navigationController!.pushViewController(vc!, animated: true)
        print("Global Id---",globalID)
    }
    
    @IBAction func btnNextClick(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UpdateVC") as? UpdateVC
        self.navigationController!.pushViewController(vc!, animated: true)
    }
    @objc func btnDelete(sender: UIButton)
    {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblDelete)
        let indexPath = self.tblDelete.indexPathForRow(at: buttonPosition)
        if indexPath != nil
        {
            ID = ((arrLocalData.object(at: (indexPath?.row)!) as! NSObject).value(forKey: "ID") as? Int)!
            print(ID)
            let strURL = "DELETE FROM DEMOSQL where ID='\(ID)'"
            print(strURL)
            
            let data = AFSQLWrapper.deleteDataTable(strURL)
            print(data)
            if data.Status == 1 {
                showData()
            }
        }
    }
}
