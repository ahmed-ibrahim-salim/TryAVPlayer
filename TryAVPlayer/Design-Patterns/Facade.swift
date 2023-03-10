//
//  Facade.swift
//  TryAVPlayer
//
//  Created by Ahmad medo on 10/03/2023.
//

import Foundation

// Hashing produces "hashValue" based on properties, so if we use 2 instances of an object with the same value for properties we get a tha same "hashValue"

// Hash Function and Combine
// https://www.programiz.com/swift-programming/hashable


// MARK: - Dependencies
public struct Customer {
  public let identifier: String
  public var address: String
  public var name: String
}

// now if created 2 instances with the same identifier, we get same hashValue even if other properties are same, if we used identifiers with different values & other properties are same values, we get different "hashValue".
// If we have used the name property inside the hash() function, we will get the same hash value. This is because name of both objects are the same.

extension Customer: Hashable {
    
    // here we use hash function to only depend on one property "identifier"
    
    // limit hashing to only one property, if ids are different we get diffrent hashValue, if ids are same value w get same hashValue.
// this type conforms to Hashable to enable you to use them as keys within a dictionary.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  public static func ==(lhs: Customer,
                        rhs: Customer) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

public struct Product {
    public let identifier: String
    public var name: String
    public var cost: Double
}

extension Product: Hashable {
    // here we use hash function to only depend on one property "identifier"

    // limit hashing to only one property, if ids are different we get diffrent hashValue, if ids are same value w get same hashValue.
    // this type conforms to Hashable to enable you to use them as keys within a dictionary.

  public func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }
  public static func ==(lhs: Product,
                        rhs: Product) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}

// Availability phase
public class InventoryDatabase {
    // product with count in inventory
  public var inventory: [Product: Int] = [:]
    
  public init(inventory: [Product: Int]) {
    self.inventory = inventory
  }
}

public class ShippingDatabase {
    // customer chosed list of products in shipping phase

  public var pendingShipments: [Customer: [Product]] = [:]
}


// MARK: - Facade
public class OrderFacade {
    // Facade takes both systems
    public let inventoryDatabase: InventoryDatabase
    public let shippingDatabase: ShippingDatabase
    
    public init(inventoryDatabase: InventoryDatabase,
                shippingDatabase: ShippingDatabase) {
        self.inventoryDatabase = inventoryDatabase
        self.shippingDatabase = shippingDatabase
    }
    
    // now placing a order requires alot of proccessing
    
    public func placeOrder(for product: Product,
                           by customer: Customer) {
        // 1 notify
        print("Place order for '\(product.name)' by '\(customer.name)'")
        
        // 2 check availability
        // using product as a key to get this product count in inventory, if product not found just return 0
        let count = inventoryDatabase.inventory[product, default: 0]
        guard count > 0 else {
            print("'\(product.name)' is out of stock!")
            return
        }
        
        // 3
        inventoryDatabase.inventory[product] = count - 1
        
        // 4
        // using customer as a key to get list of product for that customer, if customer not found just return []

        var shipments = shippingDatabase.pendingShipments[customer, default: []]
        shipments.append(product)
        shippingDatabase.pendingShipments[customer] = shipments
        
        // 5
        print("Order placed for '\(product.name)' " +
              "by '\(customer.name)'")
    }
}
