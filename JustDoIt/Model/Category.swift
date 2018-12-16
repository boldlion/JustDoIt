//
//  Category.swift
//  JustDoIt
//
//  Created by Bold Lion on 7.12.18.
//  Copyright © 2018 Bold Lion. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String = ""
    
    let items = List <Item>()
}
