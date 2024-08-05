//
//  AddPlanet.swift
//  Planetary App
//
//  Created by David Chandra on 22/06/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPlanetView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    @State private var planetName: String = ""
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImageData: Data? //To save
    @State private var images: [UIImage] = []    //To preview
    var body: some View {
        NavigationStack {
            Form {
                Section("Add New Planet") {
                    TextField("Planet Name", text: $planetName)
                }
                Section("Planet Image") {
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1) {
                        Text("Choose Image")
                    }
                    .onChange(of: selectedPhotos) {
                        convertPhotos()
                    }
                }
                ForEach(images, id: \.self) { uiImage in
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                        .padding(.vertical, 5)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresented = false
                    }, label: {
                        Text("Cancel")
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        savePlanet()
                        isPresented = false
                    }, label: {
                        Text("Save")
                    })
                }
            })
        }
    }
    func savePlanet() {
        let planet = Planet(name: planetName, picture: selectedImageData)
        modelContext.insert(planet)
        print("Saved")
    }
    
    func convertPhotos() {
        images.removeAll()
        
        for eachPhotoItem in selectedPhotos {
            Task {
                if let imageData = try? await
                    eachPhotoItem.loadTransferable(type: Data.self) {
                    selectedImageData = imageData
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
            }
        }
    }
}

#Preview {
    AddPlanetView(isPresented: .constant(false))
}
