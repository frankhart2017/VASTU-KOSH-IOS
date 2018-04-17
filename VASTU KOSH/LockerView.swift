import UIKit

class LockerView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = 0
    var imageNumber = 0
    var isSliderOpen = false
    
    //Side menu
    @IBOutlet weak var sideMenu: NSLayoutConstraint!
    
    //Text field outlets.
    @IBOutlet weak var iname: UITextField!
    @IBOutlet weak var itype: UITextField!
    @IBOutlet weak var isubtype: UITextField!
    //Ends here.
    
    //Dropdown outlets.
    @IBOutlet weak var dropdownType: UITableView!
    @IBOutlet weak var dropdownSubtype: UITableView!
    //Ends here.
    
    //Image loading text
    @IBOutlet weak var imageLoading: UILabel!
    
    //Activity Indicator
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Image
    @IBOutlet weak var selectedImage: UIImageView!
    
    //Actions.
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
    
    @IBAction func lockerButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        
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
        
        if(iname.text != "" && itype.text != "" && isubtype.text != "" && imageSelected == 1) {
            
            let url1 = "http://vastukosh-com.stackstaging.com?locker=1&id=90&name=Ananthu%20Nair"
            
            let name = iname.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let type = itype.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let subtype = isubtype.text?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let image = "image" + String(imageNumber) + ".jpg"
            
            let url2 = "&iname=" + name! + "&type=" + type!
            let url3 = "&subtype=" + subtype! + "&image=" + image
            
            let url = URL(string: url1 + url2 + url3)
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            let success = jsonResult["sent"] as? Int
                            
                            DispatchQueue.main.async(execute: {
                                
                                if(success == 1) {
                                    
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
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    //Ends here.
    
    //Arrays.
    var type = ["Books", "Clothes and Accessories", "Home Appliance", "Luggage", "Electronic Gadgets", "Kitchenware", "Sports and Fitness", "Musical Instruments", "Gaming Accessories"]
    var Books = ["Fiction", "School", "Children's", "Examination", "Textbook", "Language", "Non-fiction", "Miscellaneous"]
    var ClothesAndAccessories = ["Shoes", "Sportswear", "Handbags and clutches", "Shorts", "Shirt", "T-Shirt", "Jeans", "Suits and blazers", "Trousers", "Track pants", "Sweatshirts and hoodies", "Sweater", "Jacket", "Other winterwear", "Salwar suit", "Saree", "Tops and tees", "Nightwear"]
    var HomeAppliance = ["Electric kettle", "Vacuum cleaner", "Oven", "Heater"]
    var Luggage = ["Backpacks", "Rucksacks", "Suitcases and trolley bags"]
    var ElectronicGadgets = ["Laptop", "Mobile", "Tablet", "Speaker", "Camera and accessories", "Computer and accessories", "Printer", "Scanner"]
    var Kitchenware = ["Mixer grinder", "Toaster", "Sandwich maker", "Gas stove", "Induction", "Juicer", "Air fryer", "Electric cooker", "Dining set", "Cookware"]
    var SportsAndFitness = ["Cricket", "Badminton", "Football", "Hockey", "Other sports", "Exercise and fitness materials (30kg max)"]
    var MusicalInstruments = ["Guitar", "Keyboard", "Drumset", "Sitar", "Harmonium", "Miscellaneous"]
    var GamingAccessories = ["Consoles", "Gaming CDs", "Accessories"]
    var subtype : [String] = []
    //Ends here
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        self.imageSelected = 1
        
    }
    
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://vastukosh-com.stackstaging.com/upload.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(selectedImage.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: nil, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        imageLoading.isHidden = false
        
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
                    self.imageLoading.isHidden = true
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if(tableView == dropdownType) {
            count = type.count
        } else if(tableView == dropdownSubtype) {
            count = subtype.count
        }
        return count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        if(tableView == dropdownType) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell")
            cell!.textLabel!.text = type[indexPath.row]
            
        } else if(tableView == dropdownSubtype) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell1")
            cell!.textLabel!.text = subtype[indexPath.row]
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == dropdownType) {
            
            itype.text = type[indexPath.row]
            dropdownType.isHidden = true
            
        } else if(tableView == dropdownSubtype) {
            
            isubtype.text = subtype[indexPath.row]
            dropdownSubtype.isHidden = true
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == itype) {
            
            dropdownType.isHidden = false
            dropdownSubtype.isHidden = true
            
        } else if(textField == isubtype) {
            
            dropdownSubtype.isHidden = false
            dropdownType.isHidden = true
            
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(textField == itype) {
            
            if(itype.text == "Books") {
                subtype = Books
            } else if(itype.text == "Clothes and Accessories") {
                subtype = ClothesAndAccessories
            } else if(itype.text == "Home Appliance") {
                subtype = HomeAppliance
            } else if(itype.text == "Luggage") {
                subtype = Luggage
            } else if(itype.text == "Electronic Gadgets") {
                subtype = ElectronicGadgets
            } else if(itype.text == "Kitchenware") {
                subtype = Kitchenware
            } else if(itype.text == "Sports and Fitness") {
                subtype = SportsAndFitness
            } else if(itype.text == "Musical Instruments") {
                subtype = MusicalInstruments
            } else if(itype.text == "Gaming Accessories") {
                subtype = GamingAccessories
            }
            dropdownSubtype.reloadData()
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.iname.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.iname.layer.borderWidth = CGFloat(Float(2.0))
        self.iname.layer.cornerRadius = CGFloat(Float(10.0))
        self.itype.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.itype.layer.borderWidth = CGFloat(Float(2.0))
        self.itype.layer.cornerRadius = CGFloat(Float(10.0))
        self.isubtype.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.isubtype.layer.borderWidth = CGFloat(Float(2.0))
        self.isubtype.layer.cornerRadius = CGFloat(Float(10.0))
        
        
        
        activityIndicator.isHidden = true
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com?getImage=1")
        
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
        
        sideMenu.constant = -180
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenRightSwiped))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenLeftSwiped))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(leftSwipe)
        
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }

}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
