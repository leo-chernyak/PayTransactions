//
//  ProductsViewController.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift

final class ProductsViewController: UITableViewController {
    private var products: Results<Product>!
    private var notificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        setupProductsList()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTransactions", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TransactionsViewController
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        destinationVC.selectedProductId = products?[indexPath.row].id
        
        
    }

    func setupProductsList() {
        let realm = try? Realm()
        products = realm?.objects(Product.self)
        notificationToken = products?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}
