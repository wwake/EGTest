//
//  File.swift
//  
//
//  Created by Bill Wake on 1/2/23.
//

import Foundation

struct EG<Input, Output> {
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
    _ tests: [EG<Input, Output>],
    _ parameterizedAssert: (EG<Input, Output>) -> ())
  {
    tests.forEach { parameterizedAssert($0) }
  }
}

struct Test<Input, Output> {
  let assert: ((EG<Input, Output>) -> ())
  let examples: [EG<Input, Output>]
}

@resultBuilder struct Check2<Input, Output> {
  
  static public func buildBlock( 
    _ components: EG<Input, Output>... 
  ) -> [EG<Input,Output>] {
    Array(components)
  }
  
//  static public func buildExpression(_ expression: EG<Input, Output>) -> 
//  EG<Input, Output> {
//    expression
//  }
}

@resultBuilder struct Check3<Input, Output> {
  
  static public func buildBlock( 
    _ component: @escaping Assert<Input,Output>) 
  -> Assert<Input,Output> {
    return component
  }
  
//  static public func buildExpression(_ expression: @escaping Assert<Input,Output>) -> 
//  Assert<Input, Output> {
//    expression
//  }
}

typealias Assert<Input,Output> = (EG<Input,Output>) -> ()

//func myAsserter2<Input, Output>(_ assert: Assert<Input,Output>) {
//  
//}
//
//func myAsserter<Input, Output>(examples: [EG<Input, Output>]) -> ((Assert<Input,Output>) -> ()) {
//  
//}

func Examples<Input,Output>(@Check2<Input,Output> _ content: () -> [EG<Input, Output>], _ assert: Assert<Input,Output>) -> () {
  Check.examples(content(), assert)
}


func Checking<Input,Output>(@Check3<Input,Output>  content: @escaping Assert<Input,Output>) -> (Assert<Input, Output>) {
  return content
}
