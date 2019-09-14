//
//  TransactionTableViewCell.swift
//  PayTransactions App
//
//  Created by LeoChernyak on 11/09/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let identifier = "TransactionCell"
    
    func configure(with: Transaction){
        self.textLabel?.text = "\(with.sku) - \(with.currency): \(with.amount); GBP: \(with.amountGBP)"
    }    
}
    


