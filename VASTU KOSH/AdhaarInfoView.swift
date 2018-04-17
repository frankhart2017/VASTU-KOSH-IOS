//
//  AdhaarInfoView.swift
//  VASTU KOSH
//
//  Created by Shashank Pandey on 06/02/18.
//  Copyright © 2018 Siddhartha Dhar Choudhury. All rights reserved.
//

import UIKit

class AdhaarInfoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var adhaarField: UITextField!
    @IBOutlet weak var imageUpload: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    @IBAction func upload(_ sender: Any) {
        
        if(imageSelected == 1) {
            myImageUploadRequest()
        } else {
            
            let alert = UIAlertController(title: "Error!!", message: "Select an image first!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    @IBAction func submit(_ sender: Any) {
        
        if(adhaarField.text != "" && imageSelected == 1) {
            
            if(adhaarField.text?.count == 12) {
                
                let url1 = "http://vastukosh-com.stackstaging.com?putAdhaar=1"
                let url2 = "&adhaar=" + adhaarField.text!
                let url3 = "&image=image" + String(self.imageNumber) + ".jpg"
                let url4 = "&id=90"
                
                let url = URL(string: url1+url2+url3+url4)
                
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let image = jsonResult["imgNumber"] as? Int
                                
                                DispatchQueue.main.async(execute: {
                                    
                                    if(image == 1) {
                                        
                                        let alert = UIAlertController(title: "Success!!", message: "Data updated successfully!", preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                        
                                    }
                                    
                                })
                                
                                
                            } catch {
                                
                                print("JSON Processing Failed")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                task.resume()
                
            } else {
                
                let alert = UIAlertController(title: "Error!!", message: "Invalid adhaar number!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
        } else {
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    var imageSelected = 0
    var imageNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.adhaarField.layer.borderWidth = CGFloat(2.0)
        self.adhaarField.layer.cornerRadius = CGFloat(Float(10.0))
        self.adhaarField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        
        activityIndicator.isHidden = true
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com?getIdImage=1")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        self.imageNumber = (jsonResult["imgNumber"] as? Int)!
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.imageSelected = 1
        
    }
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://vastukosh-com.stackstaging.com/idupload.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(selectedImage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        imageUpload.isHidden = false
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json!)
                
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.selectedImage.image = nil
                    self.imageUpload.isHidden = true
                    let alert = UIAlertController(title: "Success!!", message: "Image Uploaded Successfully!", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(ok)
                    
                    self.present(alert, animated: true, completion: nil)
                })
                
            }catch
            {
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "image" + String(imageNumber) + ".jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.adhaarField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.adhaarField.layer.borderWidth = CGFloat(Float(2.0))
        self.adhaarField.layer.cornerRadius = CGFloat(Float(10.0))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
