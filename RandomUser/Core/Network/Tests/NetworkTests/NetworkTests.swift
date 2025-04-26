import XCTest
@testable import NetworkLayer

// MARK: - Test Doubles

struct MockDecodable: Codable, Equatable {
    let id: Int
    let name: String
}

struct MockError: Error, Equatable {
    let description: String
}

class MockURLSession: URLSessionProtocol {
    var request: URLRequest?
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        self.request = request
        
        if let error = error {
            throw error
        }
        
        guard let data = data, let response = response else {
            throw URLError(.badServerResponse)
        }
        
        return (data, response)
    }
}

struct MockEndpoint: EndPoint {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var parameters: [String: String]?
    
    init(baseURL: String = "https://test.com",
         path: String = "/test",
         method: HTTPMethod = .get,
         parameters: [String: String]? = ["param1": "value1"]) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
    }
}

// MARK: - NetworkService Tests

final class NetworkServiceTests: XCTestCase {
    
    var sut: NetworkService!
    var mockURLSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = NetworkService(session: mockURLSession)
    }
    
    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }
    
    // MARK: - Request Success Cases
    
    func test_request_whenSuccessful_shouldReturnDecodedObject() async {
        // Given
        let expectedResult = MockDecodable(id: 1, name: "Test")
        let testData = try! JSONEncoder().encode(expectedResult)
        let testResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        mockURLSession.data = testData
        mockURLSession.response = testResponse
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            let result: MockDecodable = try await sut.request(endpoint)
            
            // Then
            XCTAssertEqual(result, expectedResult)
        } catch {
            XCTFail("Request should succeed but failed with error: \(error)")
        }
    }
    
    func test_request_shouldUseCorrectURLRequest() async {
        // Given
        let testData = try! JSONEncoder().encode(MockDecodable(id: 1, name: "Test"))
        let testResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        mockURLSession.data = testData
        mockURLSession.response = testResponse
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            
            // Then
            XCTAssertEqual(mockURLSession.request?.url?.absoluteString, "https://test.com/test?param1=value1")
            XCTAssertEqual(mockURLSession.request?.httpMethod, "GET")
        } catch {
            XCTFail("Request should succeed but failed with error: \(error)")
        }
    }
    
    func test_request_whenDecodingFails_shouldThrowDecodingError() async {
        // Given
        let invalidData = Data("invalid json".utf8)
        let testResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        mockURLSession.data = invalidData
        mockURLSession.response = testResponse
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            XCTFail("Request should fail with decodingError")
        } catch {
            // Then
            XCTAssertEqual(error as? NetworkError, NetworkError.decodingError)
        }
    }
    
    func test_request_whenNetworkFails_shouldPropagateError() async {
        // Given
        let expectedError = URLError(.notConnectedToInternet)
        mockURLSession.error = expectedError
        
        let endpoint = MockEndpoint()
        
        // When
        do {
            let _: MockDecodable = try await sut.request(endpoint)
            XCTFail("Request should fail with network error")
        } catch {
            // Then
            XCTAssertEqual(error as? URLError, expectedError)
        }
    }
}

// MARK: - EndPoint Tests

final class EndPointTests: XCTestCase {
    
    func test_urlRequest_shouldCreateCorrectRequest() {
        // Given
        let endpoint = MockEndpoint(
            baseURL: "https://api.com",
            path: "/emircanuzel",
            method: .post,
            parameters: ["page": "1"]
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "POST")
    }
    
    func test_urlRequest_withEmptyParameters_shouldCreateRequestWithoutQuery() {
        // Given
        let endpoint = MockEndpoint(
            baseURL: "https://api.test.com",
            path: "/emircanuzel",
            method: .get,
            parameters: nil
        )
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.url?.absoluteString, "https://api.test.com/emircanuzel")
    }
}

// MARK: - RandomUserEndPoint Tests

final class RandomUserEndPointTests: XCTestCase {
    
    func test_getUsersEndpoint_shouldHaveCorrectProperties() {
        // Given
        let endpoint = RandomUserEndPoint.getUsers(page: 9999)
        
        // When
        let baseURL = endpoint.baseURL
        let path = endpoint.path
        let method = endpoint.method
        let parameters = endpoint.parameters
        
        // Then
        XCTAssertEqual(baseURL, "https://randomuser.me")
        XCTAssertEqual(path, "/api/")
        XCTAssertEqual(method, .get)
        XCTAssertEqual(parameters?["results"], "15")
        XCTAssertEqual(parameters?["page"], "9999")
    }
    
    func test_getUsersEndpoint_shouldCreateCorrectURLRequest() {
        // Given
        let endpoint = RandomUserEndPoint.getUsers(page: 2)
        
        // When
        let request = endpoint.urlRequest
        
        // Then
        XCTAssertNotNil(request)
        XCTAssertEqual(request?.httpMethod, "GET")
    }
}
