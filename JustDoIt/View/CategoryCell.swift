//
//  CategoryCell.swift
//  JustDoIt
//
//  Created by Bold Lion on 5.12.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var category: Category? {
        didSet {
            updateView()
        }
    }
    
    
    func updateView() {
        if let name = category?.name {
            textLabel?.text = name
        } else {
            textLabel?.text = "No categories added yet"
        }
    }

}
