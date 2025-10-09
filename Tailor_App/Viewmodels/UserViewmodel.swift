//
//  UserViewmodel.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//
import CoreData
import Foundation
import UIKit
class UserViewmodel : ObservableObject {
    @Published var users : [UserModel] = []
    private let context : NSManagedObjectContext
    init (context : NSManagedObjectContext) {
        self.context = context
    }
    
    func addUser (ownerName : String, shopeName : String, phoneNumber : String, image : UIImage?) {
        var imageName: String? = nil
           if let validImage = image {
               imageName = ImageManager.shared.saveImage(validImage)
           }
        let model = UserModel(ownerName: ownerName, shopName: shopeName, phoneNumber: phoneNumber, photoPath: imageName)
        let entity = UserEntity(context: context)
        entity.update(from: model, to: context)
        fetchUser()
        saveContext()
    }
    func fetchUser () {
        let requext : NSFetchRequest <UserEntity> = UserEntity.fetchRequest()
        do {
            let entities = try context.fetch(requext)
            users = entities.map{UserModel(entity: $0)}
            saveContext()
        } catch  {
            
        }
    }
    func saveContext () {
        do {
            try context.save()
        } catch  {
            
        }
    }
    func deleteUser(_ user: UserModel) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                saveContext()
                fetchUser()
            }
        } catch {
            print("❌ Failed to delete user: \(error)")
        }
    }
    
    func updateUser (_ user : UserModel, ownerName : String, shopeName : String, phoneNumber : String, image : UIImage?) {
        var imageName: String? = nil
           if let validImage = image {
               imageName = ImageManager.shared.saveImage(validImage)
           }
        let request : NSFetchRequest <UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)
        do {
          let entities =  try context.fetch(request)
            if let entity = entities.first {
                entity.ownerName = ownerName
                entity.phoneNumber = phoneNumber
                entity.shopName = shopeName
                entity.photoPath = imageName
                saveContext()
                fetchUser()
            }
        } catch  {
            
        }
    }
}
