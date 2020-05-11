//
//  VOPTransaction.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 11/05/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

struct VOPTransaction {
    
    // MARK: - Helpers
    
    enum TransactionType {
        case auth
        case settlement
    }
    
    // MARK: - Properties
    
    let cardId: String
    let externalUserId: String
    var messageElementsCollection: [VOPMessageElement]
    let messageId: String
    let messageName: String
    let userDefinedFieldsCollection: [VOPMessageElement]
    let userProfileId: String
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()
    
    // MARK: - Initialisation
    
    init(withTransaction transaction: Transaction, type: TransactionType) {
        cardId = transaction.settlementKey
        externalUserId = transaction.cardToken
        messageId = "12345678"
        messageName = "AuthMessageTest"
        userProfileId = ""
        
        let transactionAmount = String(format: "%.02f", Double(transaction.amount) / 100.0)
        let transactionDate = dateFormatter.string(from: transaction.date)
        let storeName = "Bink Shop"
        
        messageElementsCollection = [
            VOPMessageElement(key: "Transaction.BillingAmount", value: transactionAmount),
            VOPMessageElement(key: "Transaction.TimeStampYYMMDD", value: transactionDate),
            VOPMessageElement(key: "Transaction.MerchantCardAcceptorId", value: "32423 ABC"),
            VOPMessageElement(key: "Transaction.MerchantAcquirerBin", value: "3423432"),
            VOPMessageElement(key: "Transaction.TransactionAmount", value: transactionAmount),
            VOPMessageElement(key: "Transaction.VipTransactionId", value: <#T##String#>),
            VOPMessageElement(key: "Transaction.VisaMerchantName", value: storeName),
            VOPMessageElement(key: "Transaction.VisaMerchantId", value: transaction.mid),
            VOPMessageElement(key: "Transaction.VisaStoreName", value: storeName),
            VOPMessageElement(key: "Transaction.VisaStoreId", value: transaction.mid),
            VOPMessageElement(key: "Transaction.CurrencyCodeNumeric", value: "840"),
            VOPMessageElement(key: "Transaction.BillingCurrencyCode", value: "840"),
            VOPMessageElement(key: "Transaction.USDAmount", value: transactionAmount),
            VOPMessageElement(key: "Transaction.MerchantLocalPurchaseDate", value: <#T##String#>),
            VOPMessageElement(key: "Transaction.MerchantGroup.0.Name", value: <#T##String#>),
            VOPMessageElement(key: "Transaction.MerchantGroup.0.ExternalId", value: <#T##String#>),
            VOPMessageElement(key: "Transaction.AuthCode", value: <#T##String#>),
            VOPMessageElement(key: "Transaction.PanLastFour", value: transaction.lastFour),
        ]
                
        let transactionTypeValue: String
        
        switch type {
        case .auth:
            messageElementsCollection.append(contentsOf: [
                VOPMessageElement(key: "Transaction.SettlementDate", value: ""),
                VOPMessageElement(key: "Transaction.SettlementAmount", value: 0),
                VOPMessageElement(key: "Transaction.SettlementCurrencyCodeNumeric", value: 0),
                VOPMessageElement(key: "Transaction.SettlementBillingAmount", value: 0),
                VOPMessageElement(key: "Transaction.SettlementBillingCurrency", value: ""),
                VOPMessageElement(key: "Transaction.SettlementUSDAmount", value: 0),
                VOPMessageElement(key: "Transaction.MerchantDateTimeGMT", value: "") // "2019-12-19T23:40:00"
            ])
            transactionTypeValue = "AUTH"
            
        case .settlement:
            messageElementsCollection.append(contentsOf: [
                VOPMessageElement(key: "Transaction.SettlementDate", value: dateFormatter.string(from: Date())),
                VOPMessageElement(key: "Transaction.SettlementAmount", value: transactionAmount),
                VOPMessageElement(key: "Transaction.SettlementCurrencyCodeNumeric", value: 826),
                VOPMessageElement(key: "Transaction.SettlementBillingAmount", value: transactionAmount),
                VOPMessageElement(key: "Transaction.SettlementBillingCurrency", value: "GBP"),
                VOPMessageElement(key: "Transaction.SettlementUSDAmount", value: transactionAmount),
                VOPMessageElement(key: "Transaction.MerchantDateTimeGMT", value: transactionDate)
            ])
            transactionTypeValue = "SETTLE"
        }
        
        userDefinedFieldsCollection = [
            VOPMessageElement(key: "TransactionType", value: transactionTypeValue)
        ]
    }
}

/// An item that can appear in a VOP transaction
struct VOPMessageElement {
    let key: String
    let value: VOPMessageElementCompatible
}

/*
 Some items are raw numbers, others are strings. This allows our element to be either a String or Int and can live happily
 alongside each other. Since both String and Int are Codable compliant, we have no concern since they are only read when
 being encoded
 */
protocol VOPMessageElementCompatible: Codable {}
extension String: VOPMessageElementCompatible {}
extension Int: VOPMessageElementCompatible {}

/*
 SETTLEMENT
 ================================================
 return {
     "CardId": transaction["settlement_key"][:9],
     "ExternalUserId": token,
     "MessageElementsCollection": [
         {"Key": "Transaction.BillingAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.TimeStampYYMMDD", "Value": pendulum.instance(transaction["date"]).isoformat()},
         {"Key": "Transaction.MerchantCardAcceptorId", "Value": "32423 ABC"},
         {"Key": "Transaction.MerchantAcquirerBin", "Value": "3423432"},
         {"Key": "Transaction.TransactionAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.VipTransactionId", "Value": get_transaction_id()},
         {"Key": "Transaction.VisaMerchantName", "Value": "Bink Shop"},
         {"Key": "Transaction.VisaMerchantId", "Value": fixture["mid"]},
         {"Key": "Transaction.VisaStoreName", "Value": "Bink Shop"},
         {"Key": "Transaction.VisaStoreId", "Value": fixture["mid"]},
         {"Key": "Transaction.SettlementDate", "Value": pendulum.now().isoformat()},
         {"Key": "Transaction.SettlementAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.SettlementCurrencyCodeNumeric", "Value": 826},
         {"Key": "Transaction.SettlementBillingAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.SettlementBillingCurrency", "Value": "GBP"},
         {"Key": "Transaction.SettlementUSDAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.CurrencyCodeNumeric", "Value": "840"},
         {"Key": "Transaction.BillingCurrencyCode", "Value": "840"},
         {"Key": "Transaction.USDAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.MerchantLocalPurchaseDate ", "Value": "2019-12-19"},
         {"Key": "Transaction.MerchantGroup.0.Name", "Value": "TEST_MG"},
         {"Key": "Transaction.MerchantGroup.0.ExternalId", "Value": "MYSTORE"},
         {"Key": "Transaction.MerchantDateTimeGMT", "Value": pendulum.instance(transaction["date"]).isoformat(),},
         {"Key": "Transaction.AuthCode", "Value": "800533"},
         {"Key": "Transaction.PanLastFour", "Value": "2345"},
     ],
     "MessageId": "12345678",
     "MessageName": "SettlementMessageTest",
     "UserDefinedFieldsCollection": [{"Key": "TransactionType", "Value": "SETTLE"}],
     "UserProfileId": "f292f99d-babf-528a-8d8a-19fa5f14f4",
 }

 */

/*
 AUTH
 ================================================
 return {
     "CardId": transaction["settlement_key"][:9],
     "ExternalUserId": token,
     "MessageElementsCollection": [
         {"Key": "Transaction.BillingAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.TimeStampYYMMDD", "Value": pendulum.instance(transaction["date"]).isoformat()},
         {"Key": "Transaction.MerchantCardAcceptorId", "Value": "32423 ABC"},
         {"Key": "Transaction.MerchantAcquirerBin", "Value": "3423432"},
         {"Key": "Transaction.TransactionAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.VipTransactionId", "Value": get_transaction_id()},
         {"Key": "Transaction.VisaMerchantName", "Value": "Bink Shop"},
         {"Key": "Transaction.VisaMerchantId", "Value": fixture["mid"]},
         {"Key": "Transaction.VisaStoreName", "Value": "Bink Shop"},
         {"Key": "Transaction.VisaStoreId", "Value": fixture["mid"]},
         {"Key": "Transaction.SettlementDate", "Value": ""},
         {"Key": "Transaction.SettlementAmount", "Value": 0},
         {"Key": "Transaction.SettlementCurrencyCodeNumeric", "Value": 0},
         {"Key": "Transaction.SettlementBillingAmount", "Value": 0},
         {"Key": "Transaction.SettlementBillingCurrency", "Value": ""},
         {"Key": "Transaction.SettlementUSDAmount", "Value": 0},
         {"Key": "Transaction.CurrencyCodeNumeric", "Value": "840"},
         {"Key": "Transaction.BillingCurrencyCode", "Value": "840"},
         {"Key": "Transaction.USDAmount", "Value": to_pounds(transaction["amount"])},
         {"Key": "Transaction.MerchantLocalPurchaseDate ", "Value": "2019-12-19"},
         {"Key": "Transaction.MerchantGroup.0.Name", "Value": "TEST_MG"},
         {"Key": "Transaction.MerchantGroup.0.ExternalId", "Value": "MYSTORE"},
         {"Key": "Transaction.MerchantDateTimeGMT ", "Value": "2019-12-19T23:40:00"},
         {"Key": "Transaction.AuthCode", "Value": "800533"},
         {"Key": "Transaction.PanLastFour", "Value": "2345"},
     ],
     "MessageId": "12345678",
     "MessageName": "AuthMessageTest",
     "UserDefinedFieldsCollection": [{"Key": "TransactionType", "Value": "AUTH"}],
     "UserProfileId": "f292f99d-babf-528a-8d8a-19fa5f14f4",
 }

 */
