//
//  Image_FeedTests.swift
//  Image FeedTests
//
//  Created by Alexey Kremnev on 1/22/25.
//

@testable import Image_Feed
import XCTest

final class WebViewTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewControllerCallsViewDidLoad() {
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDodLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: AuthHelper(configuration: AuthConfiguration.standard))
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.isLoadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // given
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        // when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        // given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        // when
        let url = authHelper.getAuthURL()!
        let urlString = url.absoluteString

        // then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        // given
        let expectedCode = "test code"
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [ URLQueryItem(name: "code", value: "test code") ]
        let url = urlComponents.url!
        let authHelper = AuthHelper(configuration: AuthConfiguration.standard)
        
        // when
        let code = authHelper.code(from: url)
        
        // then
        XCTAssertEqual(code, expectedCode)
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var isLoadRequestCalled = false
    var presenter: (any Image_Feed.WebViewPresenterProtocol)?
    
    func load(request: URLRequest) {
        isLoadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
    }
    
    func setProgressHidden(_ isHidden: Bool) {
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDodLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDodLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
