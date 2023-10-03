import XCTest

@testable import DealDetailsFeature

class DealDetailsService: DealDetailsLoader {
    
    private let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load(dealID: String) async -> DetailsResult {
        let result = await client.perform(request: anyRequest())
        
        switch result {
        case .success(let (data, response)):
            // TODO: - handle data and response
            return .success(.mock)
        case .failure(let error):
            return .failure(.unloadable)
        }
    }
}

protocol HTTPClient {
    func perform(request: URLRequest) async -> Result<(Data, URLResponse), Error>
}


final class DealDetailsLoaderTests: XCTestCase {

    func test() async {
        let validResponse = (Data(), httpResponse(code: 200))
        let expectedResult: Result<DealDetails, LoaderError> = .success(DealDetails(id: "1", name: "Deal 1"))
        
        let sut = makeSUT(with: .success(validResponse))
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, expectedResult)
    }

    // MARK: - Helpers
    
    private func makeSUT(with result: Result<(Data, URLResponse), Error>) -> DealDetailsService {
        let client = HTTPClientStub(result: result)
        return DealDetailsService(client: client)
    }
    
    // MARK: - HTTPClientStub
    
    private class HTTPClientStub: HTTPClient {
        let result: Result<(Data, URLResponse), Error>
        
        init(result: Result<(Data, URLResponse), Error>) {
            self.result = result
        }
        
        func perform(request: URLRequest) async -> Result<(Data, URLResponse), Error> {
            return result
        }
    }

}

private func anyURL() -> URL {
    URL(string: "any-url.com")!
}

private func anyRequest() -> URLRequest {
    URLRequest(url: anyURL())
}

private func httpResponse(code: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: anyURL(), statusCode: code, httpVersion: nil, headerFields: nil)!
}

