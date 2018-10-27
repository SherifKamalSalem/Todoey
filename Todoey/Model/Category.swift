//
//  Category.swift
//  Todoey
//
//  Created by Sherif Kamal on 10/26/18.
//  Copyright © 2018 Sherif Kamal. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
    
}
