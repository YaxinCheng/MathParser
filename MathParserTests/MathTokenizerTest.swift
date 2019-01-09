//
//  MathTokenizerTest.swift
//  StringEvaluatorTests
//
//  Created by Yaxin Cheng on 2019-01-08.
//  Copyright © 2019 Yaxin Cheng. All rights reserved.
//

import XCTest
@testable import MathParser

class MathTokenizerTest: XCTestCase {
  
  var tokenizer: MathTokenizer!
  
  override func setUp() {
    tokenizer = MathTokenizer()
  }
  
  func testTokenizeWithEmptyString() {
    let result = try! tokenizer.tokenize(expression: "")
    XCTAssert(result.isEmpty)
  }
  
  func testLowBinaryOperation() {
    for expression in ["1 + 2", "3-4"] {
      let tokens = try! tokenizer.tokenize(expression: expression)
      XCTAssertEqual(tokens.count, 3)
      if case .number = tokens[0],
        case .binaryOpLow = tokens[1],
        case .number = tokens[2] {
        XCTAssert(true)
      } else {
        XCTFail()
      }
    }
  }
  
  func testHighBinaryOperation() {
    for expression in ["1*2", "4/2"] {
      let tokens = try! tokenizer.tokenize(expression: expression)
      XCTAssertEqual(tokens.count, 3)
      if case .number = tokens[0],
        case .binaryOpHigh = tokens[1],
        case .number = tokens[2] {
        XCTAssert(true)
      } else {
        XCTFail()
      }
    }
  }
  
  func testTopBinaryOperation() {
    for expression in ["5 % 2", "2**2"] {
      let tokens = try! tokenizer.tokenize(expression: expression)
      XCTAssertEqual(tokens.count, 3)
      if case .number = tokens[0],
        case .binaryOpTop = tokens[1],
        case .number = tokens[2] {
        XCTAssert(true)
      } else {
        XCTFail()
      }
    }
  }
  
  func testBrackets() {
    let tokens = try! tokenizer.tokenize(expression: "(3)")
    XCTAssertEqual(tokens.count, 3)
    if case .openBracket = tokens[0],
      case .number = tokens[1],
      case .closeBracket = tokens[2] {
      XCTAssert(true)
    } else { XCTFail() }
  }
  
  func testSpecialNumber() {
    for expression in ["π", "e", "PI", "pi"] {
      let tokens = try! tokenizer.tokenize(expression: expression)
      XCTAssertEqual(tokens.count, 1)
      if case .number = tokens[0] { XCTAssert(true) }
      else { XCTFail() }
    }
  }
  
  func testUnaryOperator() {
    for expression in ["log2(5)", "log10(5)", "log(5)", "ln(5)", "sqrt(5)", "√(5)", "exp(5)", "cosh(5)", "sinh(5)", "cos(5)", "tanh(5)", "tan(5)", "sin(5)", "floor(5)", "ceil(5)"] {
      let tokens = try! tokenizer.tokenize(expression: expression)
      XCTAssertEqual(tokens.count, 4)
      if case .unaryOp = tokens[0],
        case .openBracket = tokens[1],
        case .number = tokens[2],
        case .closeBracket = tokens[3] {
        XCTAssert(true)
      } else { XCTFail() }
    }
  }
  
  func testExtraToken() {
    do {
      _ = try tokenizer.tokenize(expression: "8x")
      XCTFail()
    } catch {
      if case MathParserError.extraToken = error {
        XCTAssert(true)
      } else { XCTFail(error.localizedDescription) }
    }
  }
}
