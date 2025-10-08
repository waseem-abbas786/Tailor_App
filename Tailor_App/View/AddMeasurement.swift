//
//  AddMeasurement.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 08/10/2025.
//

import SwiftUI

struct AddMeasurement: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var measuremntVm : MeasurementViewmodel
    @Environment(\.managedObjectContext) private var viewContext
    
    let customerId: UUID
    
    @State var chest : Double = 0
    @State var waist : Double = 0
    @State var hips : Double = 0
    @State var sleeves : Double = 0
    @State var length : Double = 0
    @State var shoulder : Double = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                ScrollView {
                    VStack (spacing : 0) {
                        HStack (spacing: 0){
                            Text("Chest Size")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("Chest Size", value: $chest, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        HStack (spacing: 0){
                            Text("Waist Size")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("waist Size", value: $waist, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        HStack (spacing: 0){
                            Text("Hip Size")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("Hip Size", value: $hips, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        HStack (spacing: 0){
                            Text("Sleeves Size")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("Sleeves Size", value: $sleeves, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        HStack (spacing: 0){
                            Text("Length")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("Length", value: $length, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        HStack (spacing: 0){
                            Text("Shoulder Size")
                                .foregroundStyle(Color.white.opacity(0.9))
                                .modernButtonStyle(color: .gray.opacity(0.6), cornerRadius: 10, height: 62)
                            TextField("Shoulder Size", value: $shoulder, format: .number)
                                .modernTextFieldStyle()
                        }
                        .padding()
                        Button("Save") {
                            measuremntVm.addMeasurement(chest: chest, waist: waist, hips: hips, sleeves: sleeves, lenght: length, shoulder: shoulder, customerId: customerId)
                            dismiss()
                        }
                        .modernButtonStyle()
                      
                    }
                }
               
                .navigationTitle("Measurements")
            }
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let measurementVm = MeasurementViewmodel(context: context)
    AddMeasurement(measuremntVm: measurementVm,  customerId: UUID())
}
