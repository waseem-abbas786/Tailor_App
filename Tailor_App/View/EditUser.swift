//
//  EditCustomer.swift
//  Tailor_App
//
//  Created by Waseem Abbas on 09/10/2025.
//

import SwiftUI
import PhotosUI

struct EditAdminView: View {
    @ObservedObject var userVm: UserViewmodel
    @Environment(\.dismiss) var dismiss
    var user: UserModel
    
    @State private var ownerName: String
    @State private var shopName: String
    @State private var phoneNumber: String
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    
    init(userVm: UserViewmodel, user: UserModel) {
        self.userVm = userVm
        self.user = user
        _ownerName = State(initialValue: user.ownerName)
        _shopName = State(initialValue: user.shopName)
        _phoneNumber = State(initialValue: user.phoneNumber)
        
        if let path = user.photoPath,
           let image = ImageManager.shared.loadImage(path) {
            _selectedImage = State(initialValue: image)
        } else {
            _selectedImage = State(initialValue: nil)
        }
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // MARK: - Profile Image
                        ZStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .shadow(radius: 6)
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                                    .foregroundColor(.gray.opacity(0.7))
                            }
                        }
                        
                        PhotosPicker(selection: $photoItem, matching: .images) {
                            Text("Change Profile Photo")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.white.opacity(0.3))
                                .clipShape(Capsule())
                        }
                        
                        // MARK: - Input Fields
                        TextField("Owner Name", text: $ownerName)
                            .modernTextFieldStyle()
                        
                        TextField("Shop Name", text: $shopName)
                            .modernTextFieldStyle()
                        
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .modernTextFieldStyle()
                        
                        // MARK: - Save Button
                        Button {
                            userVm.updateUser(
                                user,
                                ownerName: ownerName,
                                shopeName: shopName,
                                phoneNumber: phoneNumber,
                                image: selectedImage
                            )
                            dismiss()
                        } label: {
                            Text("Save Changes")
                                .font(.headline)
                        }
                        .modernButtonStyle()
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Edit Profile 🖋️")
        }
        .onChange(of: photoItem) { _, newItem in
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

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let vm = UserViewmodel(context: context)
    let user = UserModel(ownerName: "Waseem", shopName: "Tailor Master", phoneNumber: "03001234567", photoPath: nil)
    return EditAdminView(userVm: vm, user: user)
}
