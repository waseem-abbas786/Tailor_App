//
//  Customer.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import SwiftUI
import CoreData

struct Customer: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var customerVm : CustomerViewmodel
    init (context : NSManagedObjectContext ) {
        _customerVm = StateObject(wrappedValue: CustomerViewmodel(context: context))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient( gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                VStack {
                 if customerVm.customers.isEmpty {
                        emptyStateView
                    }
                    else {
                        ScrollView {
                            VStack {
                                ForEach(customerVm.customers) { customer in
                                customerCard(for: customer)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AddCustomer(customerVm: customerVm)
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .navigationTitle("Customers")
        .onAppear {
            customerVm.fetchCustomer()
        }
    }
    var emptyStateView : some View {
        VStack {
            Image(systemName: "person.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
            Text("No customer Yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            NavigationLink {
                AddCustomer(customerVm: customerVm )
            } label: {
                Text("Add Customer")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
            }

        }
        .transition(.opacity.combined(with: .scale))
    }
    private func customerCard(for customer : CustomerModel) -> some View {
        NavigationLink {
            MeasurementView(customer: customer)
        } label: {
            HStack {
               if let imageName = customer.photoPath,
                  let uiImage = ImageManager.shared.loadImage(imageName) {
                   Image(uiImage: uiImage)
                       .resizable()
                       .scaledToFill()
                       .frame(width: 70, height: 70)
                       .clipShape(Circle())
                       .shadow(radius: 5)
               } else {
                   Image(systemName: "person.circle")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 70, height: 70)
                       .foregroundStyle(.gray)
               }
               
               VStack {
                   Text(customer.name)
                       .font(.title3)
                       .bold()
                   Text(customer.phoneNumber)
                       .font(.headline)
                       .foregroundStyle(.secondary)
                   Text(customer.orderDescription)
                       .font(.caption)
                       .foregroundStyle(.secondary)
                   Text("D Date: \(customer.deliveryDate.formatted(date: .abbreviated, time: .omitted))")
               }
               Spacer()
               Button {
                   withAnimation {
                       customerVm.deleteCustomer(customer)
                   }
               } label: {
                   Image(systemName: "trash")
                       .foregroundStyle(.red)
                       .font(.title3)
               }
           }
           .padding()
           .background(.ultraThinMaterial)
           .clipShape(RoundedRectangle(cornerRadius: 15))
           .shadow(radius: 3)
        }


    }
}


#Preview {
    Customer(context: PersistenceController.shared.container.viewContext)
}
