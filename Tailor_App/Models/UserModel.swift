//
//  UserModel.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import Foundation
import CoreData

struct UserModel: Identifiable {
    let id: UUID
    var ownerName: String
    var shopName: String
    var phoneNumber: String
    var photoPath: String?
    init(id: UUID = UUID(), ownerName: String, shopName: String, phoneNumber: String, photoPath: String? = nil) {
        self.id = id
        self.ownerName = ownerName
        self.shopName = shopName
        self.phoneNumber = phoneNumber
        self.photoPath = photoPath
    }
    
}
extension UserModel {
    init (entity: UserEntity) {
        self.id = entity.id ?? UUID()
        self.ownerName = entity.ownerName ?? ""
        self.phoneNumber = entity.phoneNumber ?? ""
        self.shopName = entity.shopName ?? ""
        self.photoPath = entity.photoPath
    }
}
extension UserEntity {
    func update (from model : UserModel , to context : NSManagedObjectContext) {
        self.id = model.id
        self.ownerName = model.ownerName
        self.phoneNumber = model.phoneNumber
        self.photoPath = model.photoPath
        self.shopName = model.shopName
    }
}
