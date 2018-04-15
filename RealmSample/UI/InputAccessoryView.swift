//
//  InputAccessoryView.swift
//  AssetFolio
//
//  Created by AssetFolio on 2018/03/22.
//  Copyright © 2018年 AssetFolio. All rights reserved.
//

import UIKit

let kAccessoryViewHeight: CGFloat = 40.0

protocol InputAccessoryViewDelegate: NSObjectProtocol {
    func inputAccessoryView(_ accessoryView: InputAccessoryView, onCanceled sender: UIButton)
    func inputAccessoryView(_ accessoryView: InputAccessoryView, onConfirmed sender: UIButton)
}

class InputAccessoryView: UIView {
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    weak var delegate: InputAccessoryViewDelegate?
    
    private var view: UIView!
    
    override var backgroundColor: UIColor? {
        get {
            return self.view.backgroundColor
        }
        set(value) {
            self.view.backgroundColor = value
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.fromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.fromNib()
    }
    
    private func fromNib() {
        self.view = Bundle.main.loadNibNamed("InputAccessoryView", owner: self, options: nil)?.first as! UIView
        self.view.frame = self.bounds
        self.addSubview(self.view)
        
        self.cancelButton.contentHorizontalAlignment = .left
        self.confirmButton.contentHorizontalAlignment = .right
    }
    
    @IBAction func onCancelButtonTapped(_ sender: UIButton) {
        self.delegate?.inputAccessoryView(self, onCanceled: sender)
    }
    
    @IBAction func onConfirmButtonTapped(_ sender: UIButton) {
        self.delegate?.inputAccessoryView(self, onConfirmed: sender)
    }

}
