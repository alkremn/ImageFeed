//
//  Image_FeedUITests.swift
//  Image FeedUITests
//
//  Created by Alexey Kremnev on 1/22/25.
//

import XCTest

final class Image_FeedUITests: XCTestCase {

    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {        
        let button = app.buttons["Authenticate"]
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        
        let webView = app.webViews["UnsplashWebView"]

        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        loginTextField.tap()
        loginTextField.typeText("")
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))

        passwordTextField.tap()
        passwordTextField.typeText("")
        webView.swipeUp()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(2)
        let tablesQuery = app.tables
            
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["like_button_off"].tap()
        cellToLike.buttons["like_button_on"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(2)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["nav_back_button_white"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
       
        XCTAssertTrue(app.staticTexts[""].exists)
        XCTAssertTrue(app.staticTexts[""].exists)
        
        app.buttons["logout_button"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
