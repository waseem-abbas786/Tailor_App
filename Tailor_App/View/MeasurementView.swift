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
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack {
                    if measurementVm.measurements.isEmpty {
                        emptyStateView
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(measurementVm.measurements) { measurement in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("📏 Measurement Details")
                                            .font(.headline)
                                        Divider()
                                        
                                        Group {
                                            measurementRow(label: "Chest", value: measurement.chest)
                                            measurementRow(label: "Waist", value: measurement.waist)
                                            measurementRow(label: "Hips", value: measurement.hips)
                                            measurementRow(label: "Sleeves", value: measurement.sleeves)
                                            measurementRow(label: "Length", value: measurement.length)
                                            measurementRow(label: "Shoulder", value: measurement.shoulder)
                                        }
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        Button("delete") {
                                            measurementVm.deleteMeasurement(measurement, for: customer.id)
                                        }
                                        .transition(.opacity.combined(with: .scale))
                                        .modernButtonStyle()
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
            }
            .navigationTitle("\(customer.name) 📐")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddMeasurement(measuremntVm: measurementVm, customerId: customer.id)
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
    
    // MARK: - Helpers
    private func measurementRow(label: String, value: Double) -> some View {
        HStack {
            Text("\(label):")
            Spacer()
            Text("\(value, specifier: "%.2f")")
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "ruler")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
            
            Text("No Measurements Yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            NavigationLink {
                AddMeasurement(measuremntVm: measurementVm, customerId: customer.id)
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
