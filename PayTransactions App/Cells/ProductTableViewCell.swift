//
//  CellConfigure.swift
//  PayTransactions App
//
//  Created by LeoChernyak on 10/09/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit


class ProductTableViewCell: UITableViewCell {
    static let identifier = "ProductCell"
    
    func configure(with: Product){
        let cellText = "Product = \(with.name ). \nNum of transactions  \(with.numOfTransactions )"
        self.textLabel?.text = cellText
        self.textLabel?.sizeToFit()
        self.textLabel?.numberOfLines = 0
    }
}
