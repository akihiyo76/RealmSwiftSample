//
//  DetailControllerViewController.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import UIKit

let kDidUpdateNotificationKey = "kDidUpdateNotificationKey"

class DetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = user.name
        self.tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "identifier")
    }

    @IBAction func onSaveButtonTapped(_ sender: Any) {
        DatabaseManager.sharedInstance.insertUser(self.user) { results in
            guard let users = results else { return }
            NotificationCenter.default.post(name: .DidUpdateUserNotification, object: nil, userInfo: [kDidUpdateNotificationKey : users])
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.titles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "identifier", for: indexPath as IndexPath) as! DetailTableViewCell
        cell.tag = indexPath.row
        cell.configure(self.user)
        return cell
    }
}
