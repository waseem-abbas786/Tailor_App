//
//  CustomerViewmodel.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 06/10/2025.
//

import Foundation
import CoreData
import UIKit

class CustomerViewmodel : ObservableObject {
    @Published var customers : [CustomerModel] = []
    private let  context : NSManagedObjectContext
    init (context : NSManagedObjectContext) {
        self.context = context
    }
    
    func addCustomer (name: String, phoneNumber : String, orderDescription : String, image : UIImage?, deliveryDate : Date) {
        var imageName : String? = nil
        if let validImage = image {
            imageName = ImageManager.shared.saveImage(validImage)
        }
        let model = CustomerModel(name: name, phoneNumber: phoneNumber, orderDescription: orderDescription, deliveryDate: deliveryDate, photoPath: imageName)
        let entity = CustomerEntity(context: context)
        entity.updateCustomer(from: model, to: context)
        fetchCustomer()
        saveContext()
    }
    func fetchCustomer () {
        let request = NSFetchRequest<CustomerEntity>(entityName: "CustomerEntity")
        do {
            let fetched = try context.fetch(request)
            customers = fetched.map { entity in
                CustomerModel(
                    id: entity.id ?? UUID(),
                    name: entity.name ?? "",
                    phoneNumber: entity.phoneNumber ?? "",
                    orderDescription: entity.orderDescription ?? "",
                    deliveryDate: entity.deliveryDate ?? .now,
                    photoPath: entity.photoPath
                )
            }
        } catch {
            print("Error fetching customers: \(error)")
        }
    }
    func saveContext () {
        do {
            try context.save()
        } catch  {
            
        }
    }
    func deleteCustomer (_ customer : CustomerModel ) {
        let request : NSFetchRequest <CustomerEntity> = CustomerEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", customer.id as CVarArg)
        do {
           let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                saveContext()
                fetchCustomer()
            }
        } catch  {
            
        }
    }
    func editCustomer (_ customer : CustomerModel,name: String, phoneNumber : String, orderDescription : String, deliveryDate : Date) {
        let reuest : NSFetchRequest <CustomerEntity> = CustomerEntity.fetchRequest()
        reuest.predicate = NSPredicate(format: "id == %@", customer.id as CVarArg)
        do {
          let entities =  try context.fetch(reuest)
            if let entity = entities.first {
                entity.name = name
                entity.phoneNumber = phoneNumber
                entity.orderDescription = orderDescription
                entity.deliveryDate =  deliveryDate
                saveContext()
                fetchCustomer()
            }
        } catch  {
            
        }
    }
    
}
