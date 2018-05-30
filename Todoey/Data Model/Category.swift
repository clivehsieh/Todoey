//
//  Category.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/5/22.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
