//
//  Item.swift
//  Todoey
//
//  Created by Clive Hsieh on 2018/5/22.
//  Copyright © 2018年 Clive Hsieh. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
