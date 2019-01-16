//
//  MathParserTest.swift
//  StringEvaluatorTests
//
//  Created by Yaxin Cheng on 2019-01-08.
//  Copyright © 2019 Yaxin Cheng. All rights reserved.
//

import XCTest
@testable import MathParser

class MathParserTest: XCTestCase {
  
  var parser: MathParser!
  
  override func setUp() {
    parser = MathParser()
  }
  
  func testNormalParse() {
    let result = try! parser.parse(expression: "3*(4+2)% 2+ceil(π)")
    XCTAssertEqual(result, 4)
  }
  
  func testInvalidTokenError() {
    testError(expression: "3*4x", errorInfo: "Extra tokens",
              expectedError: .invalidToken(value: "x"))
  }
  
  func testMissingBracketError() {
    testError(expression: "3*√4+2", errorInfo: "Missing Bracket",
              expectedError: .missingBracket)
  }
  
  func testUnclosedBracketError() {
    testError(expression: "3*(4+2", errorInfo: "Unclosed Bracket",
              expectedError: .unclosedBracket)
  }
  
  func testExtraTokenError() {
    testError(expression: "3+4-", errorInfo: "Extra Token",
              expectedError: .extraToken)
  }
  
  func testZeroDivisionError() {
    testError(expression: "3/0", errorInfo: "Zero Division"
      , expectedError: .zeroDivision)
  }
  
  private func testError(expression: String, errorInfo: String, expectedError: MathParserError) {
    do {
      _ = try parser.parse(expression: expression)
      XCTFail(errorInfo)
    } catch {
      guard let convertedError = error as? MathParserError else { XCTFail("Random Error"); return }
      switch (convertedError, expectedError) {
      case (.extraToken, .extraToken),
           (.missingBracket, .missingBracket),
           (.unclosedBracket, .unclosedBracket),
           (.zeroDivision, .zeroDivision):
        XCTAssert(true)
      case (.invalidToken(let catched), .invalidToken(let expected)):
        XCTAssertEqual(catched, expected)
      default:
        XCTFail(errorInfo)
      }
    }
  }
}
