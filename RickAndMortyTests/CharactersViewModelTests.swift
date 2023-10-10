@testable import RickAndMorty
import XCTest

@MainActor
final class CharactersViewModelTests: XCTestCase {
    
    var sut: CharactersViewModel!
    var mockApiClient: MockAPIClient!
    var mockDelegate: CharactersViewControllerDelegateStub!
    
    override func setUp() {
        super.setUp()
        
        mockApiClient = MockAPIClient()
        mockDelegate = CharactersViewControllerDelegateStub()
        sut = CharactersViewModel(apiClient: mockApiClient)
    }
    
    override func tearDown() {
        sut = nil
        mockApiClient = nil
        mockDelegate = nil
        
        super.tearDown()
    }
    
    func testFetchDataSuccess() throws {
        let expectation = XCTestExpectation(description: "Data fetched successfully")
        
        mockApiClient.charactersResponse = CharactersResponse.sampleData()
        
        mockDelegate.didFetchWithSuccessStub = {
            
            XCTAssertEqual(
                self.mockDelegate.loadingDidChangeRecords,
                [true, false]
            )
            
            XCTAssertEqual(self.sut.characters.count, 2)
            
            expectation.fulfill()
        }
        mockDelegate.didFailStub = { _ in
            XCTFail("Wasn't supposed to fail")
            
            expectation.fulfill()
        }
        
        sut.delegate = mockDelegate
        
        sut.fetchData()
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchDataFailure() {
        let expectation = XCTestExpectation(description: "Failed to fetch data")
        
        let error = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        mockApiClient.error = error

        mockDelegate.didFetchWithSuccessStub = {
            XCTFail("Wasn't supposed to succeed")
            
            expectation.fulfill()
        }
        mockDelegate.didFailStub = { error in
            
            XCTAssertEqual(
                self.mockDelegate.loadingDidChangeRecords,
                [true, false]
            )
            
            let nsError = try! XCTUnwrap(error as? NSError)
            
            XCTAssertEqual(nsError.domain, "MockErrorDomain")
            XCTAssertEqual(nsError.code, 123)
            
            expectation.fulfill()
        }
        
        sut.delegate = mockDelegate

        sut.fetchData()

        wait(for: [expectation], timeout: 5.0)
    }
}

final class CharactersViewControllerDelegateStub: NSObject, CharactersViewControllerDelegate {
    
    var didFailStub: ((Error?) -> Void)?
    var didFetchWithSuccessStub: (() -> Void)?
    var loadingDidChangeStub: ((Bool) -> Void)?
    
    private (set) var loadingDidChangeRecords = [Bool]()
    
    func didFail(with error: Error?) {
        didFailStub?(error)
    }
    
    func didFetchWithSuccess() {
        didFetchWithSuccessStub?()
    }
    
    func loadingDidChange(loading: Bool) {
        loadingDidChangeRecords.append(loading)
        
        loadingDidChangeStub?(loading)
    }
}
