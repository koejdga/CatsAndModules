//
//  CatsAndModules_SofiiaBudilovaApp.swift
//  CatsAndModules_SofiiaBudilova
//
//  Created by Соня Буділова on 21.05.2024.
//

import Firebase
import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool
    {
        print("hi 2")
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCustomValue(totalTappedRows, forKey: FirebaseKeys.TotalTappedRows.rawValue)
        loadCustomProperties()

        return true
    }

    func loadCustomProperties() {
        if let path = Bundle.main.path(forResource: "CustomProperties", ofType: "plist") {
            if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    let plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil)
                    if let dict = plistData as? [String: Any] {
                        if let catOrDog = dict["CatOrDog"] as? String {
                            loadCats = !(catOrDog == "DOG") // by default load cats
                            print("cat or dog: \(catOrDog)")
                        }
                    }
                } catch {
                    print("ERROR: Could not read Plist: \(error)")
                }
            }
        } else {
            print("ERROR: CustomProperties.plist not found")
        }
    }
}

@main
struct CatsAndModules_SofiiaBudilovaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
