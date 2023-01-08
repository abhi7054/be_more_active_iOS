//
//  IAPService.swift
//  BMA
//
//  Created by MACBOOK on 21/07/21.
//

import Foundation
import StoreKit

protocol SubscriptionSuccessDelegate {
    func implementApi()
}

class IAPService: NSObject {
    
    private override init() {}
    static let shared = IAPService()
    var delegate: SubscriptionSuccessDelegate?
    fileprivate let receiptVerificator = InAppReceiptVerificator()
    
    // Products Arr
    var products = [SKProduct]()
    //Payment Queue used for all type of Transactions
    let paymentQueue = SKPaymentQueue.default()
    
    //==========================================
    //MARK: - getProducts
    func getProducts() {
        let products: Set = [IAPProduct.corporate.rawValue,
                             IAPProduct.enterprise.rawValue,
                             IAPProduct.essential.rawValue,
                             IAPProduct.team.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    //==========================================
    //MARK:- purchase
    func purchase(product: IAPProduct){
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue}).first else {return}
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    //MARK:- restorePurchases
    func restorePurchases(){
        print("restoring purchases...")
        paymentQueue.restoreCompletedTransactions()
    }
}

//MARK: - SKProductsRequestDelegate
extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

//MARK: - SKPaymentTransactionObserver
extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        transactions.forEach { (transaction) in
            print(transaction.transactionState.status(),transaction.payment.productIdentifier)
            switch transaction.transactionState{
            case .purchasing: break
            case .purchased: self.delegate?.implementApi()
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

//MARK:- Transaction State Extension for Easy Implementation of IAP Services
extension SKPaymentTransactionState{
    func status() -> String{
        switch self {
        case .deferred:
            DispatchQueue.main.async {
                removeLoader()
            }
            return "deferred"
        case .failed:
            DispatchQueue.main.async {
                removeLoader()
            }
            return "failed"
        case .purchased:
            DispatchQueue.main.async {
                removeLoader()
            }
            return "purchased"
        case .purchasing:
            DispatchQueue.main.async {
                showLoader()
            }
            return "purchasing"
        case .restored:
            DispatchQueue.main.async {
                removeLoader()
            }
            if AppModel.shared.currentUser.subscription {
                displayToast("Purchases restored successfully.")
            }else{ 
                displayToast("Nothing to restore. Please purchase a subscription")
            }
            return "restored"
        default: return "No State Found"
        }
    }
    
}

extension IAPService {
    // MARK: Public methods - Receipt verification
    
    /// Return receipt data from the application bundle. This is read from `Bundle.main.appStoreReceiptURL`.
    public static var localReceiptData: Data? {
        return shared.receiptVerificator.appStoreReceiptData
    }
}
