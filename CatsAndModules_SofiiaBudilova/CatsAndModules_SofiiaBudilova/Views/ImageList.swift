//
//  ImageList.swift
//  CatsAndModules
//
//  Created by Соня Буділова on 20.05.2024.
//

import FirebaseCrashlytics
import Networking
import SwiftUI

struct ImageList: View {
    @State private var images: [CatOrDogImage] = []

    private func loadImages() async {
        do {
            let loadedImages = try await getCatsOrDogs(loadCats: loadCats)
            images = loadedImages
        } catch {
            print("ERROR: Failed to fetch cat or dog images: \(error)")
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Button("Crash") {
                    fatalError("Crash was triggered")
                }
                ForEach(0 ..< images.count, id: \.self) { index in
                    NavigationLink(
                        value: index
                    ) {
                        ImageBoxView(catImage: images[index], index: index)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationDestination(
                for: Int.self,
                destination: { ImageBoxView(catImage: images[$0], index: $0, logToCrashlytics: true)
                }
            )
        }
        .onAppear {
            Task {
                await loadImages()
            }
        }
    }
}

#Preview {
    ImageList()
}
