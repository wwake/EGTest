//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation
import XCTest

public struct EG<Input, Output> {
  var input: Input
  var output : Output
  var message: String
  var line: Int
  
  public init(input: Input, output: Output,
       _ message: String = "", _ line: Int = #line) {
    self.input = input
    self.output = output
    self.message = message
    self.line = line
  }
  
  public func msg() -> String {
    return "Line \(line): \(message)"
  }
}

public typealias BinaryOp<T> = (T,T) -> T

public extension XCTestCase {
  func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ parameterizedAssert: (EG<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
  
  func eg<Input, Output>(
    input: Input, 
    output: Output,
    _ message: String = "", 
    _ line: Int = #line) 
      -> EG<Input, Output> {
    EG(input: input, output: output, message, line)
  }
}

public extension XCTestCase {  
  func eq<T: Equatable>(_ a: T, _ b: T, _ message : String = "", _ file : StaticString = #file, _ line: UInt = #line) -> Bool {
    if a == b { return true }
    XCTAssertEqual(a, b, message, file: file, line: line)
    return false
  }
}

public extension XCTestCase {
  func allPairs<T: Equatable>(
    _ values: [T], 
    _ closure: (T,T) -> Void
  ) {
    for a in values {
      for b in values {
        closure(a, b)
      }
    }
  }
  

  func checkProperty<T: Equatable>(_ a: T, _ b: T, file: StaticString = #file, line : UInt = #line, _ op: @escaping BinaryOp<T>, _ property: Property<T>) {
    if property.fn()(a,b,op) { return }

    XCTAssertEqual(op(a,b), op(b,a), "property '\(property)' does not hold for \(a) and \(b)", file: file, line: line)
  }
  
  func checkCommutative<T: Equatable>(_ values: [T], file: StaticString = #file, line : UInt = #line, _ op: @escaping (T, T) -> T) 
  {
    allPairs(values) { 
      checkProperty($0, $1, op, .commutative)
    }
  }

}

func commutes<T: Equatable>(_ a : T, _ b: T, _ op: BinaryOp<T>) -> Bool {
  op(a,b) == op(b,a)
}


public enum Property<T: Equatable> {
  case commutative
  
  func fn() -> (T, T, BinaryOp<T>) -> Bool {
    switch self {
    case .commutative: return commutes
    }
  }
}

