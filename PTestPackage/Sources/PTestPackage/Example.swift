//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation

struct Example<Input, Output> {
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
  static func checkTestCases<Input, Output>(
    _ tests: [Example<Input, Output>],
    _ parameterizedAssert: (Example<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
}
