import XCTest

public extension XCTestCase {
  func eg<Input, Output>(
    _ input: Input, 
    expect: Output,
    _ message: String = "", 
    _ file: StaticString = #file,
    _ line: UInt = #line) 
  -> EG<Input, Output> {
    EG(input, expect: expect, message, file, line)
  }
}

public extension XCTestCase {
  func check<Input, Output>(
    _ tests: EG<Input, Output>...,
    assertFunction: (EG<Input, Output>) -> ())
  {
    check(tests, assertFunction)
  }

  func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ assertFunction: (EG<Input, Output>) -> ())
  {
    tests.forEach { assertFunction($0) }
  }

  func check<Input, Output>(
    _ tests: EG<Input, Output>...,
    assertFunction: (EG<Input, Output>) throws -> Void
  ) throws {
    try check(tests, assertFunction)
  }

  func check<Input, Output>(
    _ tests: [EG<Input, Output>],
    _ assertFunction: (EG<Input, Output>) throws -> Void
  ) throws {
    try tests.forEach {
      try assertFunction($0)
    }
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
