import SwiftUI
import CoreData
import PhotosUI

struct AddAdmin: View {
    @ObservedObject var userVm: UserViewmodel
    @Environment(\.dismiss) var dismiss
    
    @State private var ownerName: String = ""
    @State private var shopName: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var selectedImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    // Profile image section
                    ZStack {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        } else {
                            Image(systemName: "person.crop.circle.fill.badge.plus")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    }
                    .onTapGesture {
                        // Open the photo picker when tapping the image
                    }
                    
                    // Photos Picker button
                    PhotosPicker(selection: $photoItem, matching: .images) {
                        Text("Select Profile Photo")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(Color.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    
                    // Text fields
                    TextField("Enter name", text: $ownerName)
                        .modernTextFieldStyle()
                    
                    TextField("Enter shop name", text: $shopName)
                        .modernTextFieldStyle()
                    
                    TextField("Enter phone number", text: $phoneNumber)
                        .modernTextFieldStyle()
                        .keyboardType(.phonePad)
                    
                    // Save button
                    Button("Save") {
                        userVm.addUser(
                            ownerName: ownerName,
                            shopeName: shopName,
                            phoneNumber: phoneNumber,
                            image: selectedImage
                        )
                        clearFields()
                        dismiss()
                    }
                    .disabled(ownerName.isEmpty || shopName.isEmpty || phoneNumber.isEmpty)
                    .modernButtonStyle()
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Add details here...")
        }
        .onChange(of: photoItem) { _ , newItem in
            // Convert selected photo to UIImage
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
    
    private func clearFields() {
        ownerName = ""
        shopName = ""
        phoneNumber = ""
        selectedImage = nil
        photoItem = nil
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let userVm = UserViewmodel(context: context)
    return AddAdmin(userVm: userVm)
}
