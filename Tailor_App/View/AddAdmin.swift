//
//  AddAdmin.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 05/10/2025.
//

import SwiftUI
import CoreData
struct AddAdmin: View {
    @ObservedObject var userVm : UserViewmodel
    @Environment(\.dismiss) var dismiss 
    @State private var ownerName : String = ""
    @State private var shopName : String = ""
    @State private var phoneNumber : String = ""
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                VStack (spacing: 30) {
                    TextField("enter name", text: $ownerName)
                        .modernTextFieldStyle()
                    TextField("enter shopname", text: $shopName)
                        .modernTextFieldStyle()
                    TextField("enter number", text: $phoneNumber)
                        .modernTextFieldStyle()
                    Button("save") {
                        userVm.addUser(ownerName: ownerName, shopeName: shopName, phoneNumber: phoneNumber)
                        ownerName = ""
                        shopName = ""
                        phoneNumber = ""
                        dismiss()
                    }
                    .disabled(ownerName.isEmpty || shopName.isEmpty || phoneNumber.isEmpty)
                    .modernButtonStyle()
                }
                
                Spacer().frame(height: 200)
            }
            .navigationTitle("Add details here...")
            
        }
    }
}
#Preview {
    let context = PersistenceController.shared.container.viewContext
    let userVm = UserViewmodel(context: context)
    return AddAdmin(userVm: userVm)
}

