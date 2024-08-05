//
//  EditPlanetView.swift
//  Planetary App
//
//  Created by David Chandra on 22/06/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPlanetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var planet: Planet?
    @State private var planetName: String = ""
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImageData: Data? //To save
    @State private var images: [UIImage] = []    //To preview
    
    var body: some View {
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
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    savePlanet()
                }, label: {
                    Text("Save")
                })
            }
        })
        .onAppear(perform: {
            if let planet = planet {
                planetName = planet.name
                    
                if let imageData = planet.picture, let uiImage = UIImage(data: imageData) {
                    self.images.append(uiImage)
                }
                
//                if let picture = planet.picture {
//                    selectedPhotos.append(planet.picture)
//                }
            }
        })
        .navigationBarTitleDisplayMode(.inline)
    }
    func savePlanet() {
        planet?.name = planetName
        planet?.picture = selectedImageData
        do {
            try modelContext.save()
            dismiss()
            print("Updated!")
        } catch {
            print("Error, \(error.localizedDescription)")
        }
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
    EditPlanetView()
}
