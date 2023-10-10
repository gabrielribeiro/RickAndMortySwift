@testable import RickAndMorty
import XCTest

@MainActor
final class APITests: XCTestCase {
    
    func testGetCharactersRealRequest() throws {
        
        let expectation = XCTestExpectation(description: "GET Characters Request")
        
        let api = API()
        
        api.getCharacters { charactersResponse in
            XCTAssert(charactersResponse.results.count > 0, "Characters count: \(charactersResponse.results.count)")
            
            expectation.fulfill()
        } fail: { error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
            } else {
                XCTFail("Unexpected response")
            }
        }

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetCharactersSuccess() throws {
        let mockService = MockNetworkService()
        mockService.dataToReturn = try CharactersResponse.sampleData().toStubData()
        
        let api = API(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Success characters response")
        
        api.getCharacters(success: { charactersResponse in
            XCTAssertEqual(charactersResponse.results, [
                Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Scientist", gender: "Male", image: "https://example.com/rick.jpg"),
                Character(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Sidekick", gender: "Male", image: "https://example.com/morty.jpg")
            ])
            
            expectation.fulfill()
        }, fail: { error in
            XCTFail("Wasn't supposed to fail")
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testGetCharactersFail() {
        let mockService = MockNetworkService()
        mockService.errorToReturn = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        
        let api = API(networkService: mockService)
        
        let expectation = XCTestExpectation(description: "Failed characters response")
        
        api.getCharacters(success: { charactersResponse in
            XCTFail("Wasn't supposed to succeed")
        }, fail: { error in
            let nsError = try! XCTUnwrap(error as? NSError)
            
            XCTAssertEqual(nsError.domain, "MockErrorDomain")
            XCTAssertEqual(nsError.code, 123)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 10.0)
    }
}
