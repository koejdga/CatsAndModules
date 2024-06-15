@testable import Networking // Replace 'Networking' with the actual name of your module
import XCTest

final class NetworkingTests: XCTestCase {
    @available(iOS 15.0.0, macOS 12.0, *)
    func testGetCats() async throws {
        let expectation = self.expectation(description: "Fetching Bengal cat images from The Cat API")
        
        Task {
            do {
                let catImages = try await getCatsOrDogs()
                XCTAssertFalse(catImages.isEmpty, "The cat images array should not be empty")
                
                for image in catImages {
                    XCTAssertNotNil(URL(string: image.url), "The image URL should be valid")
                    XCTAssertNotNil(image.id, "The image id should be valid")
                    XCTAssertTrue(image.ratio > 0, "The image ratio should be valid")
                }
                
                expectation.fulfill()
            } catch {
                XCTFail("Failed to fetch cat images: \(error)")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 10.0)
    }
}
