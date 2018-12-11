//
//  ToDoItemTVC.swift
//  JustDoIt
//
//  Created by Bold Lion on 26.11.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit

class ToDoItemTVC: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: Item? {
        didSet{
            updateView()
        }
    }
    
    func updateView() {
        if let title = item?.title {
            self.textLabel?.text = title
        } else {
            self.textLabel?.text = "No items yet"
        }
        
        if let done = item?.done  {
            accessoryType = done ? .checkmark : .none
        }
    }
}
