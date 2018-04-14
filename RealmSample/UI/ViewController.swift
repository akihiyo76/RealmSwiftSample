//
//  ViewController.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
        
    private let notificationCenter = NotificationCenter.default
    var users: Results<User>!
    let sortTitles = ["id ascending", "id descending", "name ascending", "name descending"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchUser()
        self.notificationCenter.addObserver(self, selector:#selector(didAddUser), name: .DidUpdateUserNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.searchBar.becomeFirstResponder()) {
            self.searchBar.resignFirstResponder()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailController",
            let viewController = segue.destination as? DetailViewController {
            viewController.user = sender as! User
        }
    }
    
    private func fetchUser() {
        DatabaseManager.sharedInstance.selectFromUser { results in
            guard let users = results else { return }
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    private func deleteUser(_ indexPath: IndexPath) {
        DatabaseManager.sharedInstance.deleteUser(self.users[indexPath.row]) { (results) in
            guard let users = results else { return }
            self.users = users
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc private func didAddUser(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let users = userInfo[kDidUpdateNotificationKey] as? Results<User> else {
                return
        }
        self.users = users
        self.tableView.reloadData()
    }
    
    @IBAction func onAddButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "toDetailController", sender: User())
    }
    
    @IBAction func onSortButtonTapped(_ sender: Any) {
        if self.users == nil || self.users.count == 0 {
            return
        }
        self.showAlertController()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let users = self.users else { return 0 }
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let standalone = self.users[indexPath.row].copy()
        self.performSegue(withIdentifier: "toDetailController", sender: standalone)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "delete") { (action, index) -> Void in
            self.deleteUser(indexPath)
        }
        deleteButton.backgroundColor = UIColor.red
        return [deleteButton]
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") { (action, sourceView, completionHandler) in
            completionHandler(true)
            self.deleteUser(indexPath)
        }
        let swipeAction = UISwipeActionsConfiguration(actions: [delete])
        swipeAction.performsFirstActionWithFullSwipe = false
        return swipeAction
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath as IndexPath)
        cell.textLabel?.text = String(format: "name: %@", self.users[indexPath.row].name ?? "")
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.fetchUser()
            return
        }
        
        let nameFilter = String(format: "name contains[c] '%@'", searchText)
        DatabaseManager.sharedInstance.filterUser(nameFilter) { (results) in
            guard let users = results else { return }
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
