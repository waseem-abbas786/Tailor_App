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
  
    init (context : NSManagedObjectContext) {
        _userVm = StateObject(wrappedValue: UserViewmodel(context: context))
    }
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
                VStack {
                    if !userVm.users.isEmpty {
                        VStack  {
                            ForEach (userVm.users) { user in
                                HStack (spacing: 100) {
                                    VStack {
                                        Text(user.ownerName)
                                            .font(.title)
                                        Text(user.shopName)
                                            .font(.headline)
                                        Text(user.phoneNumber)
                                            .font(.subheadline)
                                    }
                                    Button {
                                        userVm.deleteUser(user)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundStyle(Color.red)
                                    }

                                }
                                
                                    
                            }
                        }
                        .padding()
                    }
                    Spacer()
                  
                }
            }
                .toolbar {
                    if userVm.users.isEmpty {
                        withAnimation {
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink("Add Admin") {
                                    AddAdmin(userVm: userVm)
                                }
                                .padding(.trailing, 5)
                                .foregroundStyle(Color.white)
                                .background(Color.blue)
                                .clipShape(.buttonBorder)
                                
                            }
                        }
                      
                    } else {
                        ToolbarItem(placement: .topBarTrailing) {
                            Text("Edit")
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            NavigationLink("Customers") {
                                Customer()
                            }
                        }
                    }
                  
                }
            .navigationTitle("Tailor Shop")
            .onAppear {
                userVm.fetchUser()
            }
        }
    }
}

#Preview {
    userDashboard(context: PersistenceController.shared.container.viewContext)
}
