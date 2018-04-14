//
//  DetailTableViewCell.swift
//  RealmSample
//
//  Created by akihiyo76 on 2018/04/14.
//  Copyright © 2018年 akihiyo76. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    private var datePickerView: UIDatePicker!
    private var user: User!
    private var userInfo: UserInfo = .unknown
    
    override var tag: Int {
        didSet {
            self.userInfo = UserInfo(rawValue: tag)!
            self.titleLabel.text = "[\(self.userInfo.title)]"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.text = nil
        self.textField.delegate = self
        let accessoryView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: kAccessoryViewHeight))
        accessoryView.delegate = self
        self.textField.inputAccessoryView = accessoryView
        
        self.datePickerView = UIDatePicker()
        self.datePickerView.backgroundColor = UIColor.white
        self.datePickerView.datePickerMode = UIDatePickerMode.date
        self.datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }

    @objc func datePickerValueChanged(picker: UIDatePicker) {
        self.configureDateFormatter(picker.date)
    }
    
    private func configureDateFormatter(_ date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "yyyy年MM月dd日";
        self.textField.text = dateFormatter.string(from: date)
    }
    
    func configure(_ sender: User?) {
        if self.userInfo == .age {
            self.textField.keyboardType = .numberPad
        }
        
        guard let user = sender else { return }
        
        self.user = user

        if let value = user.value(forKey: self.userInfo.key) as? String {
            self.textField.text = value
        }
    }
}

extension DetailTableViewCell: InputAccessoryViewDelegate {
    func inputAccessoryView(_ accessoryView: InputAccessoryView, onCanceled sender: UIButton) {
        self.textField.text = nil
        self.textField.resignFirstResponder()
    }
    
    func inputAccessoryView(_ accessoryView: InputAccessoryView, onConfirmed sender: UIButton) {
        self.textField.resignFirstResponder()
        self.user.setValue(self.textField.text, forKey: self.userInfo.key)
    }        
}

extension DetailTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.userInfo == .birthday {
            self.textField.inputView = datePickerView
            if self.textField.text?.count == 0 {
                self.configureDateFormatter(self.datePickerView.date)
            }
        }
    }
}
