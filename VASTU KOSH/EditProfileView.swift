//
//  EditProfileView.swift
//  VASTU KOSH
//
//  Created by Shashank Pandey on 04/02/18.
//  Copyright © 2018 Siddhartha Dhar Choudhury. All rights reserved.
//

import UIKit

class EditProfileView: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var sideMenu: NSLayoutConstraint!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var oldpassField: UITextField!
    @IBOutlet weak var newpassField: UITextField!
    @IBOutlet weak var confirmpassField: UITextField!
    
    var isSliderOpen = false
    
    @IBAction func openSideMenu(_ sender: Any) {
        
        if isSliderOpen {
            
            sideMenu.constant = -180
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            
            sideMenu.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        
        isSliderOpen = !isSliderOpen
        
    }
    
    
    @IBAction func changePass(_ sender: Any) {
        oldpassField.isHidden = false
        newpassField.isHidden = false
        confirmpassField.isHidden = false
        oldpassLabel.isHidden = false
        newpassLabel.isHidden = false
        confirmpassLabel.isHidden = false
        savepassButton.isHidden = false
        
        
    }
    @IBAction func savePass(_ sender: Any) {
        if(oldpassField.text != "" && newpassField.text != "" && confirmpassField.text != "") {
            let url1 = "http://vastukosh-com.stackstaging.com?editProfile=1&id=90"
            let url2 = "&editPassword=" + newpassField.text!
            let url3 = "&editOldPassword=" + oldpassField.text!
            let url = URL(string: url1 + url2 + url3)
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            let sent = jsonResult["sent"] as? Int
                            
                            DispatchQueue.main.async(execute: {
                                
                                if(sent == 2) {
                                    let alert = UIAlertController(title: "Error!!", message: "Old password is not correct!", preferredStyle: .alert)
                                    
                                    let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    
                                    alert.addAction(ok)
                                    
                                    self.present(alert, animated: true, completion: nil)
                                } else if(sent == 1) {
                                    let alert = UIAlertController(title: "Success!!", message: "Password changed successfully", preferredStyle: .alert)
                                    
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
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func saveChanges(_ sender: Any) {
        let url1 = "http://vastukosh-com.stackstaging.com?editProfile=1&id=90"
        var nameUrl : String = ""
        var locationUrl : String = ""
        var addressUrl: String = ""
        var mobileUrl: String = ""
        if(nameField.text != "") {
            let name = nameField.text?.replacingOccurrences(of: " ", with: "%20")
            nameUrl = "&editName=" + name!
        }
        if(locationField.text != "") {
            let location = locationField.text?.replacingOccurrences(of: " ", with: "%20")
            locationUrl = "&editLocation=" + location!
        }
        if(addressField.text != "") {
            let address = addressField.text?.replacingOccurrences(of: " ", with: "%20")
            addressUrl = "&editAddress=" + address!
        }
        if(mobileField.text != "") {
            let mobile = mobileField.text?.replacingOccurrences(of: " ", with: "%20")
            mobileUrl = "&editMobile=" + mobile!
        }
        
        let url = URL(string: url1 + nameUrl + locationUrl + addressUrl + mobileUrl)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let name = jsonResult["name"] as? Int
                        let location = jsonResult["location"] as? Int
                        let address = jsonResult["address"] as? Int
                        let mobile = jsonResult["mobile"] as? Int
                        
                        var messageString : String = ""
                        
                        if(name == 1) {
                            messageString += "\r\n>Name"
                        }
                        if(location == 1) {
                            messageString += "\r\n>Location"
                        }
                        if(address == 1) {
                            messageString += "\r\n>Address"
                        }
                        if(mobile == 1) {
                            messageString += "\r\n>Mobile"
                        }
                        
                        DispatchQueue.main.async(execute: {
                            
                            if(messageString == "") {
                                let alert = UIAlertController(title: "Error!!", message: "Nothing changed!", preferredStyle: .alert)
                                
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                alert.addAction(ok)
                                
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let alert = UIAlertController(title: "Success!!", message: "The following details were changed " + messageString, preferredStyle: .alert)
                                
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
    }
    
    @IBOutlet weak var savepassButton: UIButton!
    @IBOutlet weak var oldpassLabel: UILabel!
    @IBOutlet weak var newpassLabel: UILabel!
    @IBOutlet weak var confirmpassLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sideMenu.constant = -180
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenRightSwiped))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenLeftSwiped))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(leftSwipe)
        
        oldpassField.isHidden = true
        newpassField.isHidden = true
        confirmpassField.isHidden = true
        oldpassLabel.isHidden = true
        newpassLabel.isHidden = true
        confirmpassLabel.isHidden = true
        savepassButton.isHidden = true
        self.nameField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.nameField.layer.borderWidth = CGFloat(Float(2.0))
        self.nameField.layer.cornerRadius = CGFloat(Float(10.0))
        self.locationField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.locationField.layer.borderWidth = CGFloat(Float(2.0))
        self.locationField.layer.cornerRadius = CGFloat(Float(10.0))
        self.addressField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.addressField.layer.borderWidth = CGFloat(Float(2.0))
        self.addressField.layer.cornerRadius = CGFloat(Float(10.0))
        self.mobileField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.mobileField.layer.borderWidth = CGFloat(Float(2.0))
        self.mobileField.layer.cornerRadius = CGFloat(Float(10.0))
        self.oldpassField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.oldpassField.layer.borderWidth = CGFloat(Float(2.0))
        self.oldpassField.layer.cornerRadius = CGFloat(Float(10.0))
        self.newpassField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.newpassField.layer.borderWidth = CGFloat(Float(2.0))
        self.newpassField.layer.cornerRadius = CGFloat(Float(10.0))
        self.confirmpassField.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.confirmpassField.layer.borderWidth = CGFloat(Float(2.0))
        self.confirmpassField.layer.cornerRadius = CGFloat(Float(10.0))
        
    }
    
    @objc func screenRightSwiped(_ recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.state == .recognized {
            
            sideMenu.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            isSliderOpen = !isSliderOpen
            
        }
        
    }
    
    @objc func screenLeftSwiped(_ recognizer: UISwipeGestureRecognizer) {
        
        if recognizer.state == .recognized {
            
            sideMenu.constant = -180
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
            isSliderOpen = !isSliderOpen
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
