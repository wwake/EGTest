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
  func allPairs<T1, T2>(
    _ t1s: [T1],
    _ t2s: [T2])
    -> [(T1,T2)]
  {
    var result: [(T1,T2)] = []
    for a in t1s {
      for b in t2s {
        result.append((a,b))
      }
    }
    return result
  }
  
  func allTriples<T1, T2, T3>(
    _ t1s: [T1],
  _ t2s: [T2],
    _ t3s: [T3]) 
    -> [(T1, T2, T3)]
  {
    var result: [(T1,T2,T3)] = []

    for a in t1s {
      for b in t2s {
        for c in t3s {
          result.append((a,b,c))
        }
      }
    }
    return result
  }
}

