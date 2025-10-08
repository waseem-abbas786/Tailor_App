//
//  AddMeasurement.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 08/10/2025.
//

import SwiftUI

struct AddMeasurement: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var measuremntVm: MeasurementViewmodel
    @Environment(\.managedObjectContext) private var viewContext
    
    let customerId: UUID
    
    @State private var chest: Double = 0
    @State private var waist: Double = 0
    @State private var hips: Double = 0
    @State private var sleeves: Double = 0
    @State private var length: Double = 0
    @State private var shoulder: Double = 0
    
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
                
                ScrollView {
                    VStack(spacing: 16) {
                        measurementField(title: "Chest Size", value: $chest)
                        measurementField(title: "Waist Size", value: $waist)
                        measurementField(title: "Hip Size", value: $hips)
                        measurementField(title: "Sleeves Size", value: $sleeves)
                        measurementField(title: "Length", value: $length)
                        measurementField(title: "Shoulder Size", value: $shoulder)
                        
                        Button {
                            withAnimation {
                                measuremntVm.addMeasurement(
                                    chest: chest,
                                    waist: waist,
                                    hips: hips,
                                    sleeves: sleeves,
                                    lenght: length,
                                    shoulder: shoulder,
                                    customerId: customerId
                                )
                                dismiss()
                            }
                        } label: {
                            Text("Save Measurement")
                                .font(.headline)
                        }
                        .modernButtonStyle()
                        .padding(.top, 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Add Measurement")
        }
    }
    
    // MARK: - Reusable Field
    private func measurementField(title: String, value: Binding<Double>) -> some View {
        HStack(spacing: 0) {
            Text(title)
                .foregroundStyle(Color.white.opacity(0.9))
                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
            TextField(title, value: value, format: .number)
                .modernTextFieldStyle()
        }
        .padding(.horizontal)
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let measurementVm = MeasurementViewmodel(context: context)
    AddMeasurement(measuremntVm: measurementVm, customerId: UUID())
}
