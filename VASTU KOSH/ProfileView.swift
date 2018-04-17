import UIKit

class ProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Label outlets.
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var idnoLabel: UILabel!
    //Ends here.
    
    //Table outlets.
    @IBOutlet weak var lockerTable: UITableView!
    @IBOutlet weak var rentTable: UITableView!
    @IBOutlet weak var soldTable: UITableView!
    @IBOutlet weak var giveTable: UITableView!
    //Ends here.
    
    //Image view
    @IBOutlet weak var idImage: UIImageView!
    
    var locker : [String] = []
    var rent : [String] = []
    var sell : [String] = []
    var give : [String] = []
    
    var lockeriid : [String] = []
    var rentiid : [String] = []
    var selliid : [String] = []
    var giveiid : [String] = []
    var image : String = ""
    
    var nameString = ""
    var iidString = ""
    var type = 0
    var isSliderOpen = false
    
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
    
    //Name button
    @IBAction func nameButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com/index.php?profile=1&id=90")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        let name = jsonResult["name"] as? String
                        let location = jsonResult["location"] as? String
                        let address = jsonResult["address"] as? String
                        let mobile = jsonResult["mobile"] as? String
                        let email = jsonResult["email"] as? String
                        let idno = jsonResult["idno"] as? String
                        
                        self.image = (jsonResult["idpic"] as? String)!
                        self.locker = (jsonResult["locker"] as? [String])!
                        self.rent = (jsonResult["rent"] as? [String])!
                        self.sell = (jsonResult["sell"] as? [String])!
                        self.give = (jsonResult["give"] as? [String])!
                        
                        self.lockeriid = (jsonResult["iid"] as? [String])!
                        self.rentiid = (jsonResult["rentiid"] as? [String])!
                        self.selliid = (jsonResult["selliid"] as? [String])!
                        self.giveiid = (jsonResult["giveiid"] as? [String])!
                        
                        if(self.locker.count == 0) {
                            self.locker = ["NULL"]
                        }
                        if(self.rent.count == 0) {
                            self.rent = ["NULL"]
                        }
                        if(self.sell.count == 0) {
                            self.sell = ["NULL"]
                        }
                        if(self.give.count == 0) {
                            self.give = ["NULL"]
                        }
                        
                        DispatchQueue.main.sync(execute: {
                            
                            self.nameLabel.text = name
                            self.locationLabel.text = location
                            self.addressLabel.text = address
                            self.mobileLabel.text = mobile
                            self.emailLabel.text = email
                            self.idnoLabel.text = idno
                            
                            self.lockerTable.reloadData()
                            self.rentTable.reloadData()
                            self.soldTable.reloadData()
                            self.giveTable.reloadData()
                            
                            let url1 = URL(string: "http://vastukosh-com.stackstaging.com/images/" + self.image)!
                            let request = NSMutableURLRequest(url: url1)
                            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                                data, response, error in
                                
                                if error != nil {
                                    print(error!)
                                } else {
                                  
                                    if let data = data {
                                        
                                        if let idImg = UIImage(data: data) {
                                            
                                            DispatchQueue.main.async(execute: {
                                                self.idImage.image = idImg
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        if(tableView == lockerTable) {
            count = locker.count
        } else if(tableView == rentTable) {
            count = rent.count
        } else if(tableView == soldTable) {
            count = sell.count
        } else if(tableView == giveTable) {
            count = give.count
        }
        
        return count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell?
        
        if(tableView == lockerTable) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell")
            cell!.textLabel!.text = locker[indexPath.row]
            
        } else if(tableView == rentTable) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell1")
            cell!.textLabel!.text = rent[indexPath.row]
            
        } else if(tableView == soldTable) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell2")
            cell!.textLabel!.text = sell[indexPath.row]
            
        } else if(tableView == giveTable) {
            
            cell = UITableViewCell(style: UITableViewCellStyle.default,reuseIdentifier: "Cell3")
            cell!.textLabel!.text = give[indexPath.row]
            
        }
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView == lockerTable && locker[0] != "NULL") {
            self.nameString = locker[indexPath.row]
            self.iidString = lockeriid[indexPath.row]
            self.type = 2
            performSegue(withIdentifier: "profileItem", sender: self)
        } else if(tableView == rentTable && rent[0] != "NULL") {
            self.nameString = rent[indexPath.row]
            self.iidString = rentiid[indexPath.row]
            self.type = 2
            performSegue(withIdentifier: "profileItem", sender: self)
        } else if(tableView == soldTable && self.sell[0] != "NULL") {
            self.nameString = sell[indexPath.row]
            self.iidString = selliid[indexPath.row]
            self.type = 2
            performSegue(withIdentifier: "profileItem", sender: self)
        } else if(tableView == giveTable && self.give[0] != "NULL") {
            self.nameString = give[indexPath.row]
            self.iidString = giveiid[indexPath.row]
            self.type = 3
            performSegue(withIdentifier: "profileItem", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "profileItem") {
            
            let item = segue.destination as! ProfileItemView
            
            item.name = nameString
            item.iid = iidString
            item.itype = type
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
