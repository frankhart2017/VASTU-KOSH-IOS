import UIKit

class VerifyEmailView: UIViewController {
    
    @IBAction func resendEmail(_ sender: Any) {
        
        let url = URL(string: "http://vastukosh-com.stackstaging.com/index.php?resend=1&id=90")
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
