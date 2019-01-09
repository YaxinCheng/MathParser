//
//  MathParser.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-08-08.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

/// Parse string typed math expression to its math evaluation result
public struct MathParser {
  public init() {}
  
  typealias ParseProcess = (value: Double, remaining: [MathTokenizer.Token])
  private let tokenizer = MathTokenizer()
  
  /// Parse a given string typed math expression to a math calculation result
  ///
  /// - parameter expression: the math expression which needs to be evaluated
  /// - returns: the evaluated result in Double
  /// - throws: EvaluationError when the expression is not in expected format
  ///
  /// e.g. String "3*4" will give you 12
  public func parse(expression: String) throws -> Double {
    let tokens = try tokenizer.tokenize(expression: expression)
    return try parse(tokens: tokens).value
  }
  
  private func parse(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    return try parseBinaryOpLow(tokens: tokens)
  }
  
  private func parseBinaryOpLow(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    var (value, remaining) = try parseBinaryOpHigh(tokens: tokens)
    while !remaining.isEmpty {
      guard let head = remaining.first else { throw MathParserError.extraToken }
      if case .binaryOpLow(let op) = head {
        let tail = remaining.advanced()
        let (rhs, rightRemaining) = try parseBinaryOpHigh(tokens: tail)
        remaining = rightRemaining
        value = op(value, rhs)
      } else { break }
    }
    return (value, remaining)
  }
  
  private func parseBinaryOpHigh(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    var (value, remaining) = try parseBinaryOpTop(tokens: tokens)
    while !remaining.isEmpty {
      guard let head = remaining.first else { throw MathParserError.extraToken }
      if case .binaryOpHigh(let op) = head {
        let tail = remaining.advanced()
        let (rhs, rightRemaining) = try parseBinaryOpTop(tokens: tail)
        remaining = rightRemaining
        if op(4, 2) == 2 && rhs == 0 { throw MathParserError.zeroDivision }
        value = op(value, rhs)
      } else { break }
    }
    return (value, remaining)
  }
  
  private func parseBinaryOpTop(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    var (value, remaining) = try parseUnaryOp(tokens: tokens)
    while !remaining.isEmpty {
      guard let head = remaining.first else { throw MathParserError.extraToken }
      if case .binaryOpTop(let op) = head {
        let tail = remaining.advanced()
        let (rhs, rightRemaining) = try parseUnaryOp(tokens: tail)
        remaining = rightRemaining
        if op(4, 2) == 0 && rhs == 0 { throw MathParserError.zeroDivision }
        value = op(value, rhs)
      } else { break }
    }
    return (value, remaining)
  }
  
  private func parseUnaryOp(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    guard let head = tokens.first else { throw MathParserError.extraToken }
    if case .unaryOp(let op) = head {
      let tail = tokens.advanced()
      if case .openBracket? = tail.first {
        let (value, remaining) = try parseBracket(tokens: tail)
        return (op(value), remaining)
      } else {
        throw MathParserError.missingBracket
      }
    } else {
      return try parseBracket(tokens: tokens)
    }
  }
  
  private func parseBracket(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    guard let head = tokens.first else { throw MathParserError.extraToken }
    if case .openBracket = head {
      let (value, remaining) = try parse(tokens: tokens.advanced())
      if case .closeBracket? = remaining.first {
        return (value, remaining.advanced())
      } else {
        throw MathParserError.unclosedBracket
      }
    } else {
      return try parseNumber(tokens: tokens)
    }
  }
  
  private func parseNumber(tokens: [MathTokenizer.Token]) throws -> ParseProcess {
    guard let head = tokens.first else { throw MathParserError.extraToken }
    if case .binaryOpLow(let op) = head {
      let multiplier = op(0, 1)
      let (value, tail) = try parseBracket(tokens: tokens.advanced())
      return (multiplier * value, tail)
    } else if case .number(let constant) = head {
      return (constant, tokens.advanced())
    } else {
      throw MathParserError.invalidToken(value: "\(head)")
    }
  }
}

extension Array where Element == MathTokenizer.Token {
  func advanced() -> Array<MathTokenizer.Token> {
    if self.count > 1 { return Array(self.dropFirst()) }
    else { return [] }
  }
}
