//
//  UpgradeViewController.swift
//  barksnap
//
//  Created by matt on 5/31/17.
//  Copyright © 2017 BoulevardLabs. All rights reserved.
//

import UIKit
import StoreKit

class UpgradeViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var resultLabel: UILabel!
    var activeProduct: SKProduct?
    
    @IBAction func buy(_ sender: Any) {
        
        if let activeProduct = activeProduct{
            
            print("buying product \(activeProduct.productIdentifier)")
            
            let payment = SKPayment(product: activeProduct)
            SKPaymentQueue.default().add(payment)
            
        } else {
            
            print("no product!")
            
        }
        
        
        
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("loading products...")
        
        for product in response.products {
            
            print("Product: \(product.productIdentifier), \(product.localizedTitle), \(product.price.floatValue)")
            
            activeProduct = product
            resultLabel.text = activeProduct?.localizedTitle
            
        }
        
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions{
            
            switch (transaction.transactionState){
                
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("purchased")
                resultLabel.text = "Purchase complete!"
                //apply purchase here, store data in user defaults.
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("failed")
                resultLabel.text = "Failed!"
            default:
                break
            }
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKPaymentQueue.default().add(self)


        let productIdentifiers: Set<String> = ["com.bsprotest"]
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
