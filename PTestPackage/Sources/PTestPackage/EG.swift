//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation
import XCTest

struct eg<Input, Output> {
  var input: Input
  var output : Output
  var message: String
  var line: Int
  
  init(input: Input, output: Output,
       _ message: String = "", _ line: Int = #line) {
    self.input = input
    self.output = output
    self.message = message
    self.line = line
  }
  
  func msg() -> String {
    return "Line \(line): \(message)"
  }
}

struct Check {
  static func examples<Input, Output>(
    _ tests: [eg<Input, Output>],
    _ parameterizedAssert: (eg<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
}

extension XCTestCase {  
  func eq<T: Equatable>(_ a: T, _ b: T, _ message : String = "", _ file : StaticString = #file, _ line: UInt = #line) -> Bool {
    if a == b { return true }
    XCTAssertEqual(a, b, message, file: file, line: line)
    return false
  }
}
