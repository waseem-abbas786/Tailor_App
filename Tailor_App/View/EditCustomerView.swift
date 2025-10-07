//
//  EditCustomerView.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 07/10/2025.
//

import SwiftUI

struct EditCustomerView: View {
    @ObservedObject var customerVm: CustomerViewmodel
        @Environment(\.dismiss) var dismiss
        var customer: CustomerModel
        
        @State private var name: String
        @State private var phoneNumber: String
        @State private var orderDescription: String
        @State private var deliveryDate: Date
    init(customerVm: CustomerViewmodel,customer: CustomerModel) {
        self.customerVm = customerVm
        self.customer = customer
        _name = State(initialValue: customer.name)
        _phoneNumber = State(initialValue: customer.phoneNumber)
        _orderDescription = State(initialValue: customer.orderDescription)
        _deliveryDate = State(initialValue: customer.deliveryDate)
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
                 VStack (spacing: 20) {
                  TextField("Name", text: $name)
                        .modernTextFieldStyle()
                  TextField("Phone", text: $phoneNumber)
                        .modernTextFieldStyle()
                  TextField("Description", text: $orderDescription)
                        .modernTextFieldStyle()
                  DatePicker("Delivery Date", selection: $deliveryDate, displayedComponents: .date)
                        .datePickerStyle(.automatic)
                        .padding()
                    Button {
                        customerVm.editCustomer(customer, name: name, phoneNumber: phoneNumber, orderDescription: orderDescription, deliveryDate: deliveryDate)
                        dismiss()
                    } label: {
                       Text("Save")
                    }
                    .modernButtonStyle()

                             
                }
            }
            .navigationTitle("Update Details🖋️")
        }
  
       
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
       let customerVm = CustomerViewmodel(context: context)
       
       let sampleCustomer = CustomerModel(
           name: "Ali Khan",
           phoneNumber: "03214567890",
           orderDescription: "2-piece suit with waistcoat",
           deliveryDate: Date()
       )
       
       return EditCustomerView(customerVm: customerVm, customer: sampleCustomer)
   }
