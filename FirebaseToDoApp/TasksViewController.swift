//
//  TasksViewController.swift
//  FirebaseToDoApp
//
//  Created by Татьяна on 10.02.2023.
//

import UIKit
import Firebase

class TasksViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addTapped(_ sender: UIBarButtonItem) {
    }
    
	@IBAction func signOut(_ sender: UIBarButtonItem) {
		do {
			try Auth.auth().signOut()
		} catch {
			print(error.localizedDescription)
		}
		dismiss(animated: true, completion: nil)
	}
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        cell.textLabel?.text = "Cell \(indexPath.row)"
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
