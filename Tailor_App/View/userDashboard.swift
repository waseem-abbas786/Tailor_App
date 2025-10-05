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
    @State private var ownerName : String = ""
    @State private var shopName : String = ""
    @State private var phoneNumber : String = ""
    init (context : NSManagedObjectContext) {
        _userVm = StateObject(wrappedValue: UserViewmodel(context: context))
    }
    var body: some View {
        NavigationStack {
            
            VStack {
                TextField("enter name", text: $ownerName)
                TextField("enter shopname", text: $shopName)
                TextField("enter number", text: $phoneNumber)
            }
            .textFieldStyle(.roundedBorder)
            Button("save") {
                userVm.addUser(ownerName: ownerName, shopeName: shopName, phoneNumber: phoneNumber)
            }
            if !userVm.users.isEmpty {
                VStack  {
                    List {
                        ForEach (userVm.users) { user in
                            Text(user.ownerName)
                            Text(user.shopName)
                            Text(user.phoneNumber)
                        }
                }
                  
                }
            } else {
                
            }
            
            Spacer()
            
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
