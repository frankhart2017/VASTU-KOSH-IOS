import UIKit

class ProfileItemView: UIViewController {
    
    //Label outlets.
    @IBOutlet weak var inameLabel: UILabel!
    @IBOutlet weak var onameLabel: UILabel!
    @IBOutlet weak var itypeLabel: UILabel!
    @IBOutlet weak var isubtypeLabel: UILabel!
    @IBOutlet weak var ipriceLabel: UILabel!
    //Ends here
    
    var isSliderOpen = false
    
    //Image view
    @IBOutlet weak var itemImage: UIImageView!
    
    //Side menu
    @IBOutlet weak var sideMenu: NSLayoutConstraint!
    
    //Open side menu
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
    
    var name = ""
    var iid = ""
    var itype = 0
    var itemImg : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = URL(string: "http://<website-link>/index.php?profile=" + String(itype) + "&iid=" + iid)
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let oname = jsonResult["oname"] as? String
                        let itype = jsonResult["itype"] as? String
                        let isubtype = jsonResult["isubtype"] as? String
                        let price = jsonResult["price"] as? String
                        self.itemImg = (jsonResult["image"] as? String)!
                        
                        DispatchQueue.main.sync(execute: {
                            
                            self.inameLabel.text = self.name
                            self.onameLabel.text = oname
                            self.itypeLabel.text = itype
                            self.isubtypeLabel.text = isubtype
                            if(price != "") {
                                self.ipriceLabel.text = price
                            } else {
                                self.ipriceLabel.text = ""
                            }
                            
                            let url1 = URL(string: "http://<website-link>/img/items/" + self.itemImg)!
                            let request = NSMutableURLRequest(url: url1)
                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                data, response, error in
                                
                                if error != nil {
                                    print(error!)
                                } else {
                                    
                                    if let data = data {
                                        
                                        if let iimage = UIImage(data: data) {
                                            
                                            DispatchQueue.main.async(execute: {
                                                self.itemImage.image = iimage
                                            })
                                            
                                        }
                                        
                                    }
                                    
                                }
                            }
                            
                            task.resume()
                            
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
