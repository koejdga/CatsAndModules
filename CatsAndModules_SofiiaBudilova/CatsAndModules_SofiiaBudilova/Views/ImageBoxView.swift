//
//  ContentView.swift
//  CatsAndModules
//
//  Created by Соня Буділова on 20.05.2024.
//

import FirebaseCrashlytics
import Networking
import SwiftUI

struct ImageBoxView: View {
    let imageUrl: String
    let width: CGFloat
    let height: CGFloat
    let index: Int
    let logToCrashlytics: Bool

    init(catImage: CatOrDogImage, index: Int = -1, paddingHorizontal: Int = 20, logToCrashlytics: Bool = false) {
        self.imageUrl = catImage.url
        self.width = UIScreen.main.bounds.size.width - CGFloat(paddingHorizontal * 2)
        self.height = width / CGFloat(catImage.ratio)
        self.index = index
        self.logToCrashlytics = logToCrashlytics
    }

    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: width, height: height)
        .onAppear {
            if logToCrashlytics {
                Crashlytics.crashlytics().log("selecting row at \(index) in cat images list")
                Crashlytics.crashlytics().setCustomValue(index, forKey: FirebaseKeys.LastTappedRowAt.rawValue)
                totalTappedRows += 1
                Crashlytics.crashlytics().setCustomValue(totalTappedRows, forKey: FirebaseKeys.TotalTappedRows.rawValue)
            }
        }
    }
}

#Preview {
    ImageBoxView(catImage: CatOrDogImage(id: "vm", url: "https://cdn2.thecatapi.com/images/vm.jpg", width: 453, height: 550), index: -1)
}
