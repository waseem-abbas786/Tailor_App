//
//  Measurement.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 06/10/2025.
//

import SwiftUI
import CoreData

struct MeasurementView: View {
    let customer: CustomerModel
    @StateObject var measurementVm: MeasurementViewmodel
    @Environment(\.managedObjectContext) private var viewContext
    
    init(context: NSManagedObjectContext, customer: CustomerModel) {
        self.customer = customer
        _measurementVm = StateObject(wrappedValue: MeasurementViewmodel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    if measurementVm.measurements.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(measurementVm.measurements) { measurement in
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("📏 Measurement Details")
                                                .font(.headline)
                                            Spacer()
                                        }
                                        Divider()
                                        
                                        Group {
                                            HStack {
                                                Text("Chest:")
                                                Spacer()
                                                Text("\(measurement.chest, specifier: "%.2f")")
                                            }
                                            HStack {
                                                Text("Waist:")
                                                Spacer()
                                                Text("\(measurement.waist, specifier: "%.2f")")
                                            }
                                            HStack {
                                                Text("Hips:")
                                                Spacer()
                                                Text("\(measurement.hips, specifier: "%.2f")")
                                            }
                                            HStack {
                                                Text("Sleeves:")
                                                Spacer()
                                                Text("\(measurement.sleeves, specifier: "%.2f")")
                                            }
                                            HStack {
                                                Text("Length:")
                                                Spacer()
                                                Text("\(measurement.length, specifier: "%.2f")")
                                            }
                                            HStack {
                                                Text("Shoulder:")
                                                Spacer()
                                                Text("\(measurement.shoulder, specifier: "%.2f")")
                                            }
                                        }
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        
                                        if let notes = measurement.notes, !notes.isEmpty {
                                            Text("📝 Notes: \(notes)")
                                                .font(.footnote)
                                                .foregroundStyle(.secondary)
                                                .padding(.top, 6)
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .shadow(radius: 3)
                                    .transition(.slide.combined(with: .opacity))
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("\(customer.name) 📐")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddMeasurement(measuremntVm: measurementVm)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .onAppear {
                measurementVm.fetchMeasurements(for: customer.id)
            }
        }
    }
    
    // MARK: - Empty State
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "ruler")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
                .shadow(radius: 3)
            
            Text("No Measurements Yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            NavigationLink {
                AddMeasurement(measuremntVm: measurementVm)
            } label: {
                Text("Add Measurement")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 3)
            }
        }
        .padding()
        .transition(.opacity.combined(with: .scale))
    }
}

#Preview {
    let sampleCustomer = CustomerModel(
        id: UUID(),
        name: "Waseem Abbas",
        phoneNumber: "03243",
        orderDescription: "Shalwar Kameez",
        deliveryDate: .now
    )
    MeasurementView(
        context: PersistenceController.shared.container.viewContext,
        customer: sampleCustomer
    )
}
