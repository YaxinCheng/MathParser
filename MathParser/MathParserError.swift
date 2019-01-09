//
//  MathParserError.swift
//  Tonnerre
//
//  Created by Yaxin Cheng on 2018-08-08.
//  Copyright © 2018 Yaxin Cheng. All rights reserved.
//

import Foundation

public enum MathParserError: Error {
  /// The given token is not supported
  case invalidToken(value: String)
  /// Too many tokens are passed
  case extraToken
  /// Has open bracket but not closed
  case unclosedBracket
  /// Function is not followed by a bracket
  case missingBracket
  /// Zero is used as a denominator
  case zeroDivision
}
