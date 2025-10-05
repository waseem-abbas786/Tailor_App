//
//  UserViewmodel.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//
import CoreData
import Foundation
class UserViewmodel : ObservableObject {
    @Published var users : [UserModel] = []
    private let context : NSManagedObjectContext
    init (context : NSManagedObjectContext) {
        self.context = context
    }
    
    func addUser (ownerName : String, shopeName : String, phoneNumber : String) {
        let model = UserModel(ownerName: ownerName, shopName: shopeName, phoneNumber: phoneNumber)
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
}
