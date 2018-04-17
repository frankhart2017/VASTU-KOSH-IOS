import UIKit

class RentSellView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Text Field Outlets.
    @IBOutlet weak var iid: UITextField!
    @IBOutlet weak var iprice: UITextField!
    @IBOutlet weak var ichoice: UITextField!
    @IBOutlet weak var iduration: UITextField!
    //Ends here.
    
    //Dropdown Outlets.
    @IBOutlet weak var dropdownid: UITableView!
    @IBOutlet weak var dropdownchoice: UITableView!
    //Ends here.
    
    //Side Menu.
    var isSliderOpen = false
    @IBOutlet weak var sideMenu: NSLayoutConstraint!
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
    
    @IBAction func rentButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    
    @IBAction func sellButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    //Ends here.
    
    //Submit button.
    @IBAction func submit(_ sender: Any) {
        
        if(iid.text != "" && iprice.text != "" && ichoice.text != "") {
            
            var type : String = ""
            
            if(ichoice.text == "Rent") {
                
                type = "1"
                
            } else if(ichoice.text == "Sell") {
                
                type = "2"
                
            }
            
            if(type == "2" || (type == "1" && iduration.text != "")) {
            
                let url1 = "http://vastukosh-com.stackstaging.com?iid=" + iid.text!
                let url2 = "&id=90&price=" + iprice.text!
                let url3 = "&type=" + type + "&put=1"
                var url = URL(string: url1+url2+url3)
                if(type == "1") {
                    let url4 = "&duration=" + iduration.text!
                    url = URL(string: url1+url2+url3+url4)
                }
                
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let put = jsonResult["put"] as? Int
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(put == 2) {
                                        
                                        let alert = UIAlertController(title: "Success!!", message: "Item put to respective section!", preferredStyle: .alert)
                                        
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
            
        } else {
            
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    //Ends here.
    
    //Arrays.
    var item : [String] = []
    var itemid: [String] = []
    var choice = ["Rent", "Sell"]
    //Ends here.
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.iid.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.iid.layer.borderWidth = CGFloat(Float(2.0))
        self.iid.layer.cornerRadius = CGFloat(Float(10.0))
        self.iprice.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.iprice.layer.borderWidth = CGFloat(Float(2.0))
        self.iprice.layer.cornerRadius = CGFloat(Float(10.0))
        self.ichoice.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.ichoice.layer.borderWidth = CGFloat(Float(2.0))
        self.ichoice.layer.cornerRadius = CGFloat(Float(10.0))
        self.iduration.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.iduration.layer.borderWidth = CGFloat(Float(2.0))
        self.iduration.layer.cornerRadius = CGFloat(Float(10.0))
        
        
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com?id=90&items=1")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let items = jsonResult["items"] as? Int
                        
                        self.item = (jsonResult["item"] as? [String])!
                        
                        self.itemid = (jsonResult["itemid"] as? [String])!
                        
                        DispatchQueue.main.sync(execute: {
                            
                            if(items == 0) {
                                
                                let alert = UIAlertController(title: "Error!!", message: "No items in locker!", preferredStyle: .alert)
                                
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                alert.addAction(ok)
                                
                                self.present(alert, animated: true, completion: nil)
                                
                            } else if(items == 1) {
                                
                                self.dropdownid.reloadData()
                                
                            }
                            
                        })
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
        
        sideMenu.constant = -180
        
        iduration.isHidden = true
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == iid) {
            
            dropdownchoice.isHidden = true
            dropdownid.isHidden = false
            
        } else if(textField == iprice) {
            
            dropdownchoice.isHidden = true
            dropdownid.isHidden = true
            
        } else if(textField == ichoice) {
            
            dropdownchoice.isHidden = false
            dropdownid.isHidden = true
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count : Int = 0
        
        if(tableView == dropdownid) {
            
            count =  item.count
            
        } else if(tableView == dropdownchoice) {
            
            count = 2
            
        }
        
        return count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == dropdownid) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell")
            cell!.textLabel!.text = "Id: " + itemid[indexPath.row] + ", Name: " + item[indexPath.row]
            
        } else if(tableView == dropdownchoice) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell1")
            cell!.textLabel!.text = choice[indexPath.row]
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == dropdownid) {
            
            iid.text = itemid[indexPath.row]
            dropdownid.isHidden = true
            
        } else if(tableView == dropdownchoice) {
            
            ichoice.text = choice[indexPath.row]
            dropdownchoice.isHidden = true
            if(ichoice.text == "Rent") {
                iduration.isHidden = false
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    

}
