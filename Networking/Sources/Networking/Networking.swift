// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public struct CatOrDogImage: Codable, Hashable {
    public let id: String
    public let url: String
    let width: Int
    let height: Int
    public var ratio: Float {
        Float(width) / Float(height)
    }

    public init(id: String, url: String, width: Int, height: Int) {
        self.id = id
        self.url = url
        self.width = width
        self.height = height
    }
}

@available(iOS 15.0.0, macOS 12.0, *)
public func getCatsOrDogs(loadCats: Bool = true) async throws -> [CatOrDogImage] {
    let catOrDog = loadCats ? "cat" : "dog"

    let urlString = "https://api.the\(catOrDog)api.com/v1/images/search?limit=10"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    let (data, response) = try await URLSession.shared.data(for: request)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }

    let images = try JSONDecoder().decode([CatOrDogImage].self, from: data)
    return images
}
