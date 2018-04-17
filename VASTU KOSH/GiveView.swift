import UIKit

class GiveView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBAction func giveButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    
    //Text field outlets.
    @IBOutlet weak var iid: UITextField!
    @IBOutlet weak var cname: UITextField!
    //Ends here.
    
    //Dropdown outlets.
    @IBOutlet weak var dropdownid: UITableView!
    @IBOutlet weak var dropdowncharity: UITableView!
    //Ends here.
    
    //Give away button.
    @IBAction func giveAway(_ sender: Any) {
    
        let originalString = cname.text!
        let urlString = originalString.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: "http://vastukosh-com.stackstaging.com?give=2&iid=" + iid.text! + "&charity=" + urlString)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let sent = jsonResult["sent"] as? Int
                        
                        DispatchQueue.main.sync(execute: {
                            
                            if(sent == 1) {
                                
                                let alert = UIAlertController(title: "Success!!", message: "Item listed in for charity. We will pick the item soon!", preferredStyle: .alert)
                                
                                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                
                                alert.addAction(ok)
                                
                                self.present(alert, animated: true, completion: nil)
                                
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
        
    }
    //Ends here.
    
    var charityName = ["Some Random Charity 1", "Some Random Charity 2", "Some Random Charity 3"]
    var itemid : [String] = []
    var iname : [String] = []
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if(tableView == dropdownid) {
            
            count = itemid.count
            
        } else if(tableView == dropdowncharity) {
            
            count = charityName.count
            
        }
        
        return count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == dropdownid) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell")
            cell!.textLabel!.text = "Id: " + itemid[indexPath.row] + ", Name: " + iname[indexPath.row]
 
        } else if(tableView == dropdowncharity) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell1")
            cell!.textLabel!.text = charityName[indexPath.row]
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == dropdownid) {
            
            iid.text = itemid[indexPath.row]
            dropdownid.isHidden = true
            
        } else if(tableView == dropdowncharity) {
            
            cname.text = charityName[indexPath.row]
            dropdowncharity.isHidden = true
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(textField == iid) {
            
            dropdownid.isHidden = false
            dropdowncharity.isHidden = true
            
        } else if(textField == cname) {
            
            dropdowncharity.isHidden = false
            dropdownid.isHidden = true
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.iid.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.iid.layer.borderWidth = CGFloat(Float(2.0))
        self.iid.layer.cornerRadius = CGFloat(Float(10.0))
        self.cname.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.cname.layer.borderWidth = CGFloat(Float(2.0))
        self.cname.layer.cornerRadius = CGFloat(Float(10.0))
        
        
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com/index.php?give=1&id=90")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        self.itemid = (jsonResult["iid"] as? [String])!
                        self.iname = (jsonResult["iname"] as? [String])!
                        
                        DispatchQueue.main.sync(execute: {
                            
                            self.dropdownid.reloadData()
                            
                        })
                        
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

}
