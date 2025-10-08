//
//  EditMeasurements.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 08/10/2025.
//

import SwiftUI

struct EditMeasurements: View {
    @ObservedObject var measurementVm : MeasurementViewmodel
    @Environment(\.dismiss) var dismiss
    var measurement : MeasurementModel
    
    @State private var chest: Double
    @State private var waist: Double
    @State private var hips: Double
    @State private var sleeves: Double
    @State private var length: Double
    @State private var shoulder: Double
    
    
    init(measurementVm: MeasurementViewmodel, measurement: MeasurementModel) {
        self.measurementVm = measurementVm
        self.measurement = measurement
        _chest = State(initialValue: measurement.chest)
        _waist = State(initialValue: measurement.waist)
        _hips = State(initialValue: measurement.hips)
        _sleeves = State(initialValue: measurement.sleeves)
        _length = State(initialValue: measurement.length)
        _shoulder = State(initialValue: measurement.shoulder)
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
                                measurementVm.updateMeasurements(measurement, chest: chest, waist: waist, hips: hips, sleeves: sleeves, length: length, shoulder: shoulder, customerId: measurement.customerId)
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
            .navigationTitle("Edit Measurement")
        }
    }
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
    let viewmodel = MeasurementViewmodel(context: context)
    let samplemodel = MeasurementModel(chest: 22, waist: 22, hips: 22, sleeves: 22, shoulder: 22, notes: "", customerId: UUID())
    
    EditMeasurements(measurementVm: viewmodel, measurement: samplemodel)
}
