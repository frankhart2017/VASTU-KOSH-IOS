import UIKit

class ItemView: UIViewController {
    
    var isSliderOpen = false
    
    //Outlets.
    @IBOutlet weak var iname: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var oname: UILabel!
    @IBOutlet weak var itype: UILabel!
    @IBOutlet weak var isubtype: UILabel!
    @IBOutlet weak var iprice: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var offerPrice: UITextField!
    @IBOutlet weak var sideMenu: NSLayoutConstraint!
    //Ends here.
    
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
    @IBAction func interested(_ sender: Any) {
        
        if(offerPrice.text == "") {
            
            let alert = UIAlertController(title: "Error!!", message: "Enter offer price!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            let url1 = "http://vastukosh-com.stackstaging.com/index.php?interested=1&iid=" + id
            let url2 = "&name=Ananthu&oprice=" + offerPrice.text!
            var url3 = "&type=1"
            if(pType == 2) {
                url3 = "&type=2"
            }
            
            let url = URL(string: url1+url2+url3)
            
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                
                if error != nil {
                    
                    print(error!)
                    
                } else {
                    
                    if let urlContent = data {
                        
                        do {
                            
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            let sentStatus = jsonResult["sent"] as? Int
                            
                            DispatchQueue.main.sync(execute: {
                                
                                if(sentStatus == 1) {
                                    
                                    let alert = UIAlertController(title: "Success!!", message: "Mail sent successfully!", preferredStyle: .alert)
                                    
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
        
    }
    //Ends here.
    
    var name = ""
    var id = ""
    var img = ""
    var pType = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.duration.isHidden = true

        // Do any additional setup after loading the view.
        self.offerPrice.layer.borderColor = UIColor(displayP3Red: 51/255, green: 255/255, blue: 255/255, alpha: 1).cgColor
        self.offerPrice.layer.borderWidth = CGFloat(Float(2.0))
        self.offerPrice.layer.cornerRadius = CGFloat(Float(10.0))
        
        
        
        oname.text = ""
        itype.text = ""
        isubtype.text = ""
        iprice.text = ""
        
        iname.text = name
        let imgURL = URL(string:img)
        let data = NSData(contentsOf: (imgURL)!)
        imgView.image = UIImage(data: data! as Data)
        
        var url = URL(string: "http://vastukosh-com.stackstaging.com/index.php?details=1&iid=" + id)
        
        if(pType == 2) {
            url = URL(string: "http://vastukosh-com.stackstaging.com/index.php?details=2&iid=" + id)
        }
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let ownername = jsonResult["oname"] as? String
                        let itemtype = jsonResult["itype"] as? String
                        let itemsubtype = jsonResult["isubtype"] as? String
                        let price = jsonResult["price"] as? String
                        let iduration = jsonResult["duration"] as? String
                        
                        DispatchQueue.main.sync(execute: {
                            
                            self.oname.text = ownername
                            self.itype.text = itemtype
                            self.isubtype.text = itemsubtype
                            if(self.pType == 2) {
                                self.iprice.text = "Price (per month): " + price!
                                self.duration.isHidden = false
                                self.duration.text = "Duration (in months):" + iduration!
                            } else {
                                self.iprice.text = "Price:" + price!
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
