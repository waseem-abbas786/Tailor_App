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
        let request : NSFetchRequest <CustomerEntity> = CustomerEntity.fetchRequest()
        do {
           let entities =  try context.fetch(request)
            customers = entities.map{CustomerModel(entity: $0)}
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
    
}
