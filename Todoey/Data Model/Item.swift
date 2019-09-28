//
//  Item.swift
//  Todoey
//
//  Created by Guy Nir on 28/09/2019.
//  Copyright © 2019 Guy Nir. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var isSelected : Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
