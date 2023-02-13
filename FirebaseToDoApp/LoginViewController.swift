//
//  ViewController.swift
//  FirebaseToDoApp
//
//  Created by Татьяна on 09.02.2023.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardShowAndHide()
		warnLabel.alpha = 0
		authDidChange()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		emailTextField.text = ""
		passwordTextField.text = ""
	}

    @IBAction func loginTapped(_ sender: UIButton) {
		guard let email = emailTextField.text,
			  let password = passwordTextField.text,
			  email != "",
			  password != "" else {
			displayWarningLabel(with: "Info is incorrect")
			return
		}
		
		Auth.auth().signIn(withEmail: email, password: password) { [unowned self] user, error in
			if error != nil {
				self.displayWarningLabel(with: "Error occured")
				return
			}
			
			if user != nil {
				self.performSegue(withIdentifier: "showTasks", sender: nil)
				return
			}
			
			self.displayWarningLabel(with: "No such user")
		}
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
		guard let email = emailTextField.text,
			  let password = passwordTextField.text,
			  email != "",
			  password != "" else {
			displayWarningLabel(with: "Info is incorrect")
			return
		}
		
		Auth.auth().createUser(withEmail: email, password: password) { [unowned self] user, error in
			if error == nil {
				if user != nil {
				self.performSegue(withIdentifier: "showTasks", sender: nil)
				} else {
					print("User is not created")
				}
			} else {
				print(error?.localizedDescription ?? "No localized description")
			}
		}
    }
	
	private func authDidChange() {
		Auth.auth().addStateDidChangeListener { [unowned self] auth, user in
			if user != nil {
				self.performSegue(withIdentifier: "showTasks", sender: nil)
			}
		}
	}
    
	private func displayWarningLabel(with text: String) {
		warnLabel.text = text
		
		UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut) { [unowned self] in
			self.warnLabel.alpha = 1
		} completion: { [unowned self] complete in
			self.warnLabel.alpha = 1
		}
	}
	
    private func keyboardShowAndHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func kbDidShow(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + kbFrameSize.height)
        
        (self.view as! UIScrollView).scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbFrameSize.height, right: 0)
    }
    
    @objc private func kbDidHide() {
        (self.view as! UIScrollView).contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
}

