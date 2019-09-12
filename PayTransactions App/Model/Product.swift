//
//  Product.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import Foundation
import RealmSwift


final class Product: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id: String = ""
    let transaction = Transaction()
    var transactions = List<Transaction>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
