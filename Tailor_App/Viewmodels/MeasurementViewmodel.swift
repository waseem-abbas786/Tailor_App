import Foundation
import CoreData

class MeasurementViewmodel: ObservableObject {
    @Published var measurements: [MeasurementModel] = []
    let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Add Measurement
    func addMeasurement(
        chest: Double,
        waist: Double,
        hips: Double,
        sleeves: Double,
        lenght: Double,
        shoulder: Double,
        notes: String? = nil,
        customerId: UUID
    ) {
        let model = MeasurementModel(
            chest: chest,
            waist: waist,
            hips: hips,
            sleeves: sleeves,
            length: lenght,
            shoulder: shoulder,
            notes: notes,
            customerId: customerId
        )

        let entity = MeasurementEntity(context: context)
        entity.updateMeasurement(from: model, to: context)

        saveContext()
        fetchMeasurements(for: customerId)
    }

    // MARK: - Fetch Measurements (filtered by customer)
    func fetchMeasurements(for customerId: UUID) {
        let request: NSFetchRequest<MeasurementEntity> = MeasurementEntity.fetchRequest()
        request.predicate = NSPredicate(format: "customerId == %@", customerId as CVarArg)

        do {
            let entities = try context.fetch(request)
              self.measurements = entities.map { MeasurementModel(entity: $0) }
        } catch {
            print("❌ Fetch error: \(error.localizedDescription)")
        }
    }

    // MARK: - Delete
    func deleteMeasurement(_ measurement: MeasurementModel, for customerId: UUID) {
        let request = NSFetchRequest<MeasurementEntity>(entityName: "MeasurementEntity")
        request.predicate = NSPredicate(format: "id == %@ AND customerId == %@", measurement.id as CVarArg, customerId as CVarArg)

        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                saveContext()
                fetchMeasurements(for: customerId)
            }
        } catch {
            print("Failed to delete measurement: \(error.localizedDescription)")
        }
    }


    // MARK: - Update
    func updateMeasurements(
        _ model: MeasurementModel,
        chest: Double,
        waist: Double,
        hips: Double,
        sleeves: Double,
        length: Double,
        shoulder: Double,
        notes: String? = nil,
        customerId: UUID
    ) {
        let request: NSFetchRequest<MeasurementEntity> = MeasurementEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@ AND customerId == %@", model.id as CVarArg, customerId as CVarArg)

        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                entity.chest = chest
                entity.waist = waist
                entity.hips = hips
                entity.sleeves = sleeves
                entity.lenght = length
                entity.shoulder = shoulder
                entity.notes = notes
                entity.customerId = customerId

                saveContext()
                fetchMeasurements(for: customerId)
            }
        } catch {
            print("❌ Update error: \(error.localizedDescription)")
        }
    }

    // MARK: - Save
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ Save error: \(error.localizedDescription)")
        }
    }
}
