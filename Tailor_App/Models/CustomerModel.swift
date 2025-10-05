//
//  CustomerModel.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import Foundation
import CoreData

struct CustomerModel: Identifiable {
    let id: UUID
    var name: String
    var phoneNumber: String
    var orderDescription: String
    var deliveryDate: Date
    var isCompleted: Bool
    var photoPath: String?
    init(id: UUID = UUID(), name: String, phoneNumber: String, orderDescription: String, deliveryDate: Date, isCompleted: Bool = false, photoPath: String? = nil) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.orderDescription = orderDescription
        self.deliveryDate = deliveryDate
        self.isCompleted = isCompleted
        self.photoPath = photoPath
    }
}
extension CustomerModel {
    init (entity : CustomerEntity) {
        self.id = entity.id ?? UUID()
        self.name = entity.name ?? ""
        self.phoneNumber = entity.phoneNumber ?? ""
        self.orderDescription = entity.description
        self.deliveryDate = entity.deliveryDate ?? .now
        self.isCompleted = entity.isCompleted
        self.photoPath = entity.photoPath
    }
}
extension CustomerEntity {
    func updateCustomer (from model : CustomerModel, to context : NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.phoneNumber = model.phoneNumber
        self.orderDescription = model.orderDescription
        self.deliveryDate = model.deliveryDate
        self.isCompleted = model.isCompleted
        self.photoPath = model.photoPath
    }
}

