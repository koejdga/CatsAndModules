//
//  ContentView.swift
//  CatsAndModules_SofiiaBudilova
//
//  Created by Соня Буділова on 28.05.2024.
//

import FirebaseCrashlytics
import SwiftUI

struct ContentView: View {
    @State private var showAlert = false

    func allowFirebaseCrashlyticsCollection(allow: Bool) {
        UserDefaults.standard.set(true, forKey: "FirebaseCrashlyticsCollectionEnabled_Set")
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(allow)
    }

    var body: some View {
        ImageList()
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "FirebaseCrashlyticsCollectionEnabled_Set") {
                    self.showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Збір даних"),
                    message: Text("Дозволити програмі збирати дані про збої?"),
                    primaryButton: .default(
                        Text("Дозволити"),
                        action: { allowFirebaseCrashlyticsCollection(allow: true) }
                    ),
                    secondaryButton: .destructive(
                        Text("Заборонити"),
                        action: { allowFirebaseCrashlyticsCollection(allow: false) }
                    )
                )
            }
    }
}

#Preview {
    ContentView()
}
