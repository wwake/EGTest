//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation
import XCTest

public struct EG<Input, Output> {
  public var input: Input
  public var output : Output
  public var message: String
  public var file: StaticString
  public var line: UInt
  
  public init(input: Input, output: Output,
              _ message: String = "", _ file: StaticString = #file, _ line: UInt = #line) {
    self.input = input
    self.output = output
    self.message = message
    self.file = file
    self.line = line
  }
  
  public func msg() -> String {
    return "Line \(line): \(message)"
  }
}
