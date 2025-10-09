//
//  userDashboard.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import SwiftUI
import CoreData

struct userDashboard: View {
    @Environment(\.managedObjectContext) private var viewcontext
    @StateObject var userVm : UserViewmodel
    @StateObject var customerVm : CustomerViewmodel
  
    init (context : NSManagedObjectContext) {
        _userVm = StateObject(wrappedValue: UserViewmodel(context: context))
        _customerVm = StateObject(wrappedValue: CustomerViewmodel(context: context))
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
                        if userVm.users.isEmpty {
                            emptyStateView
                        } else {
                            ScrollView {
                                VStack(spacing: 15) {
                                    ForEach(userVm.users) { user in
                                        userCard(for: user, userVm: userVm)
                                    }
                                }
                                .padding()
                            }
                            customerCount(customerVm: customerVm)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        if !userVm.users.isEmpty {
                            NavigationLink("Customers") {
                                Customer(context: viewcontext)
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        if userVm.users.isEmpty {
                            NavigationLink("Add Admin") {
                                AddAdmin(userVm: userVm)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                        } else {
                           
                        }
                    }
                }
                .navigationTitle("Tailor Shop")
                .onAppear {
                    userVm.fetchUser()
                    customerVm.fetchCustomer()
                }
            }
        }
        // MARK: - Subviews
        
        private var emptyStateView: some View {
            VStack(spacing: 15) {
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.blue)
                
                Text("No Admin Found")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                NavigationLink {
                    AddAdmin(userVm: userVm)
                } label: {
                    Text("Add Admin")
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
        
    private func userCard(for user: UserModel, userVm : UserViewmodel) -> some View {
            HStack(spacing: 16) {
                if let imageName = user.photoPath,
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
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(user.ownerName)
                        .font(.title3)
                        .bold()
                    Text(user.shopName)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text(user.phoneNumber)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                VStack (spacing: 40) {
                    NavigationLink {
                        EditAdminView(userVm: userVm, user: user)
                    } label: {
                        Text("🖋️")
                    }


                    Button {
                        withAnimation {
                            userVm.deleteUser(user)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundStyle(.red)
                            .font(.title3)
                    }
                }

            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 3)
        }
    private func customerCount (customerVm : CustomerViewmodel) -> some View {
        HStack {
                Text("Total Customers: \(customerVm.totalCustomers)")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 3)
            .padding(.horizontal)
    }
}

#Preview {
    userDashboard(context: PersistenceController.shared.container.viewContext)
}
