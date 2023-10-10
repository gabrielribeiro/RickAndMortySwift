@testable import RickAndMorty
import Foundation

extension CharactersResponse {
    static func sampleData() -> CharactersResponse {
        let character1 = Character(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Scientist", gender: "Male", image: "https://example.com/rick.jpg")
        let character2 = Character(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Sidekick", gender: "Male", image: "https://example.com/morty.jpg")
        
        let info = Info(count: 2, pages: 1, next: nil, prev: nil)
        
        let charactersResponse = CharactersResponse(info: info, results: [character1, character2])
        
        return charactersResponse
    }
}

extension Encodable {
    func toStubData() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
}

class MockAPIClient: API {
    var charactersResponse: CharactersResponse?
    var error: Error?
    
    override func getCharacters(
        success: @escaping ((CharactersResponse) -> Void),
        fail: @escaping ((Error?) -> Void)
    ) {
        if let charactersResponse = charactersResponse {
            success(charactersResponse)
        } else if let error = error {
            fail(error)
        }
    }
}

class MockNetworkService: NetworkService {
    var dataToReturn: Data?
    var responseToReturn: URLResponse?
    var errorToReturn: Error?
    
    func request<T: Codable>(_ type: T.Type, url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) {
        
        if let dataToReturn = dataToReturn {
            completionHandler(try? JSONDecoder().decode(type, from: dataToReturn), responseToReturn, errorToReturn)
        } else {
            completionHandler(nil, responseToReturn, errorToReturn)
        }
    }
}
