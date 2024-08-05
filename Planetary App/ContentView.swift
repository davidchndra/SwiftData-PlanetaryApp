//
//  ContentView.swift
//  Planetary App
//
//  Created by David Chandra on 22/06/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Planet.name, order: .forward) var planets: [Planet]
    @State var isPresented: Bool = false
    var body: some View {
        List {
            ForEach(planets, id: \.self) { item in
                NavigationLink {
                    EditPlanetView(planet: item)
                } label : {
                    HStack {
                        if let imageData = item.picture, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                        } else {
                            Image(systemName: "globe.asia.australia")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .scaledToFit()
                        }
                        Text("\(item.name)")
                            .padding()
                    }
                }
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    modelContext.delete(planets[index])
                }
            })
        }
        .listStyle(.plain)
        .navigationTitle("Solar Systems")
        .sheet(isPresented: $isPresented, onDismiss: {
            
        }, content: {
            AddPlanetView(isPresented: $isPresented)
        })
        .toolbar(content: {
            ToolbarItem {
                Button(action: {
                    isPresented.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
        })
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
