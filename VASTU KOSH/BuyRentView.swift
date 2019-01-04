import UIKit

class BuyRentView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    final let urlString = "http://<website-link>/index.php"
    var imgURLArray : [String] = []
    var nameArray : [String] = []
    var idArray : [String] = []
    
    var imgString = ""
    var nameString = ""
    var idString = ""
    var isSliderOpen = false
    var pageType = 1

    //Outlets.
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
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
    @IBAction func buyButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    @IBAction func rentButton(_ sender: Any) {
        
        sideMenu.constant = -180
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        isSliderOpen = false
        
    }
    //Ends here.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.downloadJsonWithURL()
        
        sideMenu.constant = -180
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenRightSwiped))
        rightSwipe.direction = .right
        
        view.addGestureRecognizer(rightSwipe)
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(screenLeftSwiped))
        leftSwipe.direction = .left
        
        view.addGestureRecognizer(leftSwipe)

        // Do any additional setup after loading the view.
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

    func downloadJsonWithURL() {
        
        var url = URL(string: "http://<website-link>/index.php?images=1")!
        
        if(pageType == 2) {
            url = URL(string: "http://<website-link>index.php?images=2")!
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                if let urlContent = data {
                    
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        self.imgURLArray = (jsonResult["images"] as? [String])!
                        
                        self.nameArray = (jsonResult["iname"] as? [String])!
                        
                        self.idArray = (jsonResult["iid"] as? [String])!
                        
                        DispatchQueue.main.sync(execute: {
                            
                            self.tableView.reloadData()
                            
                        })
                        
                    } catch {
                        
                        print("JSON Processing Failed")
                        
                    }
                    
                }
                
            }
            
        }
        
        task.resume()
        
    }
    
    func downloadJsonWithTask() {
        
        let url = NSURL(string: urlString)
        
        var downloadTask = URLRequest(url: (url as URL?)!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 20)
        
        downloadTask.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: downloadTask, completionHandler: {(data, response, error) -> Void in
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            
            print(jsonData!)
            
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgURLArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let imgURL = NSURL(string: imgURLArray[indexPath.row])
        cell.iname.text = nameArray[indexPath.row]
        if imgURL != nil {
            let data = NSData(contentsOf: (imgURL as URL?)!)
            cell.imgView.image = UIImage(data: data! as Data)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.nameString = nameArray[indexPath.row]
        self.imgString = imgURLArray[indexPath.row]
        self.idString = idArray[indexPath.row]
        self.performSegue(withIdentifier: "items", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "items") {
            
            let item = segue.destination as! ItemView
            
            item.name = nameString
            item.img = imgString
            item.id = idString
            item.pType = pageType
            
        }
        
    }

}
