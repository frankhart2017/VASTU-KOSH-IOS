import UIKit

class ViewController: UIViewController {
    
    var isChecked = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    //Error message label.
    @IBOutlet weak var errMessage: UILabel!
    
    //Outlets for signup form.
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signLocation: UITextField!
    @IBOutlet weak var signAddress: UITextField!
    @IBOutlet weak var signMobile: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signPassword: UITextField!
    @IBOutlet weak var signConfirmPassword: UITextField!
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var signSubmit: UIButton!
    //Ends here.
    
    //Outlets for login form.
    @IBOutlet weak var logEmail: UITextField!
    @IBOutlet weak var logPassword: UITextField!
    @IBOutlet weak var logSubmit: UIButton!
    //Ends here.
    
    //Outlets for forgot form.
    @IBOutlet weak var forgotEmail: UITextField!
    @IBOutlet weak var forgotSubmit: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    //Ends here
    
    
    @IBAction func forgotPassword(_ sender: Any) {
        
        //To show
        forgotEmail.isHidden = false
        forgotSubmit.isHidden = false
        //Show ends here
        
        //To hide
        signName.isHidden = true
        signLocation.isHidden = true
        signAddress.isHidden = true
        signMobile.isHidden = true
        signEmail.isHidden = true
        signPassword.isHidden = true
        signConfirmPassword.isHidden = true
        checkbox.isHidden = true
        termsLabel.isHidden = true
        signSubmit.isHidden = true
        
        logEmail.isHidden = true
        logPassword.isHidden = true
        logSubmit.isHidden = true
        
        forgotButton.isHidden = true
        //Hide ends here
        
    }
    
    
    @IBAction func forgot(_ sender: Any) {
        
        self.errMessage.isHidden = true
        
        if(forgotEmail.text != "") {
            if(!isValidEmail(testStr: forgotEmail.text!)) {
                let alert = UIAlertController(title: "Error!!", message: "Invalid email address!", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                let url = URL(string: "http://vastukosh-com.stackstaging.com?email="+forgotEmail.text!+"&forgot=1")!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let forgot = jsonResult["sent"] as? Int
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(forgot == 1) {
                                        let alert = UIAlertController(title: "Success!!", message: "Password reset mail sent, please check your inbox!", preferredStyle: .alert)
                                        
                                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                                        
                                        alert.addAction(ok)
                                        
                                        self.present(alert, animated: true, completion: nil)
                                    } else if(forgot == 2) {
                                        let alert = UIAlertController(title: "Error!!", message: "This email address is not linked with any account!", preferredStyle: .alert)
                                        
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
        } else {
            let alert = UIAlertController(title: "Error!!", message: "Complete the form!", preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func login(_ sender: Any) {
        
        //To show
        logEmail.isHidden = false
        logPassword.isHidden = false
        logSubmit.isHidden = false
        
        forgotButton.isHidden = false
        //Show ends here.
        
        //To hide
        signName.isHidden = true
        signLocation.isHidden = true
        signAddress.isHidden = true
        signMobile.isHidden = true
        signEmail.isHidden = true
        signPassword.isHidden = true
        signConfirmPassword.isHidden = true
        checkbox.isHidden = true
        termsLabel.isHidden = true
        signSubmit.isHidden = true
        
        forgotEmail.isHidden = true
        forgotSubmit.isHidden = true
        //Hide ends here
        
        self.scrollView.isScrollEnabled = false
        
    }
    
    @IBAction func checkboxClicked(_ sender: Any) {
        
        if !isChecked {
            checkbox.setBackgroundImage(UIImage(named: "checkmark.png"), for: UIControlState.normal)
        } else{
            checkbox.setBackgroundImage(nil, for: UIControlState.normal)
        }
        
        isChecked = !isChecked
        print(isChecked)
        
    }
    
    @IBAction func signup(_ sender: Any) {
        
        //To hide
        logEmail.isHidden = true
        logPassword.isHidden = true
        logSubmit.isHidden = true
        
        forgotEmail.isHidden = true
        forgotButton.isHidden = true
        forgotSubmit.isHidden = true
        //Hide ends here.
        
        //To show
        signName.isHidden = false
        signLocation.isHidden = false
        signAddress.isHidden = false
        signMobile.isHidden = false
        signEmail.isHidden = false
        signPassword.isHidden = false
        signConfirmPassword.isHidden = false
        checkbox.isHidden = false
        termsLabel.isHidden = false
        signSubmit.isHidden = false
        //Show ends here
        
        self.scrollView.isScrollEnabled = true
        
    }

    @IBAction func logSubmit(_ sender: Any) {
        
        if(logEmail.text != "" && logPassword.text != "") {
            
            if(isValidEmail(testStr: logEmail.text!)) {
                
                let url = URL(string: "http://vastukosh-com.stackstaging.com?email="+logEmail.text!+"&pass="+logPassword.text!+"&log=1")!
                
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let login = jsonResult["login"] as? Int
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(login == 0) {
                                        
                                        self.errMessage.text = "Account does not exist!"
                                        
                                    } else if(login == 1) {
                                        
                                        self.errMessage.text = "Login successful!"
                                        
                                    } else if(login == 2) {
                                        
                                        self.errMessage.text = "Wrong credentials!"
                                        
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
                
                errMessage.text = "Invalid email address!"
                
            }
 
        } else {
            
            errMessage.text = "Complete the form!"
            
        }
        
    }
    
    @IBAction func signSubmit(_ sender: Any) {
        
        var error = 0
        var errmsg = ""
        
        if(signName.text != "" && signLocation.text != "" && signAddress.text != "" && signMobile.text != "" && signEmail.text != "" && signPassword.text != "" && signConfirmPassword.text != "") {
            
            if(isChecked == false) {
                
                errmsg += "Agree to terms and conditions!"
                error += 1
                
            }
            
            if(!isValidEmail(testStr: signEmail.text!)) {
                
                errmsg += "\nInvalid email address"
                error += 1
                
            }
            
            if(!isValidMobile(value: signMobile.text!)) {
                
                errmsg += "\nInvalid mobile number!"
                error += 1
                
            }
            
            if(signPassword.text != signConfirmPassword.text) {
                
                errmsg += "\nPasswords do not match!"
                error += 1
                
            } else {
                
                if((signPassword.text?.count)! < 8) {
                    
                    errmsg += "\nPassword is less than 8 chars!"
                    
                }
                
            }
            
            if(errmsg != "") {
                
                let alert = UIAlertController(title: "Error!!", message: errmsg, preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alert.addAction(ok)
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let name = signName.text?.replacingOccurrences(of: " ", with: "%20")
                let location = signLocation.text?.replacingOccurrences(of: " ", with: "%20")
                let address = signAddress.text?.replacingOccurrences(of: " ", with: "%20")
                let url1 = "http://vastukosh-com.stackstaging.com?name="+name!
                let url2 = "&location="+location!+"&address="+address!
                let url21 = "&mobile="
                let url3 = signMobile.text!+"&email="+signEmail.text!
                let url31 = "&password="+signPassword.text!+"&log=2"
                
                let url = URL(string: url1+url2+url21+url3+url31)
                
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    
                    if error != nil {
                        
                        print(error!)
                        
                    } else {
                        
                        if let urlContent = data {
                            
                            do {
                                
                                let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                                
                                let signup = jsonResult["signup"] as? Int
                                
                                print(signup!)
                                
                                DispatchQueue.main.sync(execute: {
                                    
                                    if(signup == 0) {
                                        
                                        self.errMessage.text = "Account already exists!"
                                        
                                    } else if(signup == 1) {
                                        
                                        self.errMessage.text = "Signup successful!"
                                        
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
            
            
        } else {
            
            errMessage.text = "Complete the form!"
            
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidMobile(value: String) -> Bool {
        let PHONE_REGEX = "[0-9]{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.scrollView.isScrollEnabled = false
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

