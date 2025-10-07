//
//  AddCustomer.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 06/10/2025.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct AddCustomer: View {
    @ObservedObject var customerVm : CustomerViewmodel
    @Environment(\.dismiss) var dismiss
    @State private var name : String = ""
    @State private var phoneNumber : String = ""
    @State private var orderDescription : String = ""
    @State private var deliveryDate : Date = .now
    
    @State private var selectedImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack {
                    ZStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.gray.opacity(0.7))
                        }
                    }
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Text("Select Profile Photo")
                            .font(.headline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    VStack {
                        TextField("Enter Name...", text: $name)
                            .modernTextFieldStyle()
                        TextField("Enter Number...", text: $phoneNumber)
                            .modernTextFieldStyle()
                        TextField("Enter Description...", text: $orderDescription)
                            .modernTextFieldStyle()
                        DatePicker("Delivery Date", selection: $deliveryDate, displayedComponents: .date)
                            .font(.headline)
                            .padding()
                        Button("Save") {
                            customerVm.addCustomer(name: name, phoneNumber: phoneNumber, orderDescription: orderDescription, image: selectedImage, deliveryDate: deliveryDate)
                            dismiss()
                        }
                        .disabled(name.isEmpty || phoneNumber.isEmpty || orderDescription.isEmpty)
                        .modernButtonStyle()
                    }
                  
                    Spacer()
                }
                .padding()
                
            }
            .navigationTitle("Add Customer")
            .onChange(of: photoItem) { _ , newItem in
                if let newItem {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }
            }
        }
     
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let customerVm = CustomerViewmodel(context: context)
    AddCustomer(customerVm: customerVm)
}
