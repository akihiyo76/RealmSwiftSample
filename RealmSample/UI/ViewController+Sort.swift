//
//  ViewController+Sort.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/15.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {

    func showAlertController() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for (index, title) in self.sortTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .`default`, handler: { alertAction -> Void in
                let sortType = SortType(rawValue: index) ?? .id_ascending
                DatabaseManager.sharedInstance.selectTickerOrderBy(sortType) { (results) in
                    guard let users = results else { return }
                    self.users = users
                    self.tableView.reloadData()
                }
            })
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
