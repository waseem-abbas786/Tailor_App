//
//  File.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import Foundation
import CoreData

import Foundation
import CoreData

struct MeasurementModel: Identifiable {
    let id: UUID
    var chest: Double
    var waist: Double
    var hips: Double
    var sleeves: Double
    var length: Double
    var shoulder: Double
    var notes: String?
    var customerId: UUID  // ✅ link to customer
    
    init(
        id: UUID = UUID(),
        chest: Double = 0.0,
        waist: Double = 0.0,
        hips: Double = 0.0,
        sleeves: Double = 0.0,
        length: Double = 0.0,
        shoulder: Double = 0.0,
        notes: String? = nil,
        customerId: UUID
    ) {
        self.id = id
        self.chest = chest
        self.waist = waist
        self.hips = hips
        self.sleeves = sleeves
        self.length = length
        self.shoulder = shoulder
        self.notes = notes
        self.customerId = customerId
    }
}

extension MeasurementModel {
    init(entity: MeasurementEntity) {
        self.id = entity.id ?? UUID()
        self.chest = entity.chest
        self.waist = entity.waist
        self.hips = entity.hips
        self.sleeves = entity.sleeves
        self.length = entity.lenght
        self.shoulder = entity.shoulder
        self.notes = entity.notes
        self.customerId = entity.customerId ?? UUID() // ✅
    }
}

extension MeasurementEntity {
    func updateMeasurement(from model: MeasurementModel, to context: NSManagedObjectContext) {
        self.id = model.id
        self.chest = model.chest
        self.waist = model.waist
        self.hips = model.hips
        self.sleeves = model.sleeves
        self.lenght = model.length
        self.shoulder = model.shoulder
        self.notes = model.notes
        self.customerId = model.customerId // ✅
    }
}
