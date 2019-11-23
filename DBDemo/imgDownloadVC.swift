//
//  imgDownloadVC.swift
//  DBDemo
//
//  Created by Mac_01 on 19/11/19.
//  Copyright © 2019 Stegowl. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON

class imgDownloadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var img: UIImageView!
    var imagePicked = UIImageView()
    var  imagePicker = UIImagePickerController()
    var img_url = ""
    var dicProfile = NSMutableDictionary()
    
    var imagesDirectoryPath:String!
    var images:[UIImage]!
    var titles:[String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        images = []
          imagePicker.delegate = self
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Get the Document directory path
        let documentDirectorPath:String = paths[0]
        // Create a new path for the new images folder
        imagesDirectoryPath = documentDirectorPath.appendingFormat("/ImagePicker")
        var objcBool:ObjCBool = true
        let isExist = FileManager.default.fileExists(atPath: imagesDirectoryPath, isDirectory: &objcBool)
        // If the folder with the given path doesn't exist already, create it
        if isExist == false{
            do{
                try FileManager.default.createDirectory(atPath: imagesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print("Something went wrong while creating a new folder")
            }
        }
    
        // Do any additional setup after loading the view.
    }

    @IBAction func btnChoseImgClick(_ sender: UIButton) {
        
            let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let Camera = UIAlertAction(title: "Camera", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Camera")
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = .camera;
                    self.imagePicker.allowsEditing = false
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            })
            let PhotoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Gallery")
                self.imagePicker.sourceType = .savedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
                print("Cancelled")
            })
            optionMenu.addAction(Camera)
            optionMenu.addAction(PhotoLibrary)
            optionMenu.addAction(cancelAction)
            self.present(optionMenu, animated: true, completion: nil)
            present(imagePicker, animated: true, completion: nil)
            
        }
    
    
    @IBAction func btnDownloadClick(_ sender: UIButton) {
        
         self.imageUploadApiCall(image: img.image!)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil else {
            return
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // Save image to Document directory
        let imagePath = NSDate().description
//        imagePath = imagePath.stringByReplacingOccurrencesOfString(" ", withString: "")
//        imagePath = imagesDirectoryPath.stringByAppendingString("/\(imagePath).png")
        let data = UIImagePNGRepresentation(image)
        let success = FileManager.default.createFile(atPath: imagePath, contents: data, attributes: nil)
        dismiss(animated: true) { () -> Void in

        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageUploadApiCall(image : UIImage) {
        
        //SVProgressHUD.show(withStatus: "Uploading images please wait...")
//        SVProgressHUD.dismiss(withDelay: 100)
//        let token = ["Authorization": appDelegate.token,"userid": appDelegate.user_id,"fcmid": appDelegate.fcm_id]
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "dd-mm-yy-hh-mm-ss"
            let imageName = df.string(from: date as Date)
            let imageData = UIImageJPEGRepresentation(image, 0.4)
            multipartFormData.append(imageData!, withName: "vehicle_image", fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
            
        }, to: "mainURL+URLs.uploadimage.rawValue" , headers: nil) { (encodingResult) in
            switch encodingResult {
            case .success(let upload,_ ,_ ):
                upload.uploadProgress(closure: { (progress) in
                    
                })
                upload.responseJSON {
                    response in
                    let dictionary = response.result.value as Any
                    let dic = JSON(dictionary)
                    print(dic)
                    let status = dic["status"].intValue
                    if status == 1 {
                        self.img_url = dic["url"].stringValue
                        print(self.img_url)
                
                    }else{
                        print("Image")
                    }
                    
                    print(self.img_url)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
}
