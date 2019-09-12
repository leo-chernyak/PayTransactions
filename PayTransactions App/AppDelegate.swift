//
//  AppDelegate.swift
//  Pay_Check_LevCherniak
//
//  Created by LeoChernyak on 04/06/2019.
//  Copyright © 2019 LeoChernyak. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var json: [[String:Any]]?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let path = Bundle.main.path(forResource: "transactions1", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe) as Data
        json = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String:Any]]
        clearRealm()
        saveRealmObject(json: json!)
        return true
    }
    
    func saveRealmObject(json: [[String:Any]]) {
        let realm = try! Realm()
        for product in json {
            try! realm.write {
                realm.add(Product(value: ["name" : product["sku"] as? String,
                                          "id" : product["sku"] as? String]),update: true)
                realm.add(Transaction(value: ["amount" : product["amount"] as? String, "currency" : product["currency"], "sku" : product["sku"], "currencyGBP" : product["currency"]]))
            }
        }
        addTransactionsToProduct()
        currencyConverter()
    }
    
    func addTransactionsToProduct(){
        let realm = try! Realm()
        let products = realm.objects(Product.self)
        for product in products{
            print(product.id)
            let transactions = realm.objects(Transaction.self).filter("sku == %@", product.id)
            let convertedList = transactions.reduce(List<Transaction>()) { (list, element) -> List<Transaction> in
                list.append(element)
                return list
            }
            try! realm.write {product.setValue(convertedList, forKey: "transactions")}
            print(product.transactions.count)
        }
    }
    
    func currencyConverter() {
        let realm = try! Realm()
        let transactionsList = realm.objects(Transaction.self)
        let path = Bundle.main.path(forResource: "rates2", ofType: "json")
        let jsonData = try? NSData(contentsOfFile: path!, options: NSData.ReadingOptions.mappedIfSafe) as Data
        let jsonRates = try! JSONSerialization.jsonObject(with: jsonData!, options: []) as? [[String:Any]]
        var fromCurrency = ""
        var toCurrency = ""
        var rateCurrency = ""
        for transactionObject in transactionsList{
            repeat{
                var helpVar = transactionObject.currency
                var valueCurrency = transactionObject.amount!
                for rate in jsonRates!{
                    if let rateFrom = rate["from"] as? String{fromCurrency = rateFrom}
                    if let rate = rate["rate"] as? String{rateCurrency = rate}
                    if let to = rate["to"] as? String{toCurrency = to}
                    if fromCurrency == "GBP" {
                        try! realm.write {
                            transactionObject.currencyGBP = toCurrency
                            transactionObject.amountGBP = valueCurrency
                        }
                    }
                    if helpVar == fromCurrency{
                        valueCurrency = String( Double(valueCurrency)! * Double(rateCurrency)! )
                        helpVar = toCurrency
                    }
                }
            } while transactionObject.currencyGBP == "GBP"
        }
    }
    
    func clearRealm(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

