import UIKit
import XCTest

class HeapTree {
    private let isMax: Bool
    private let input: [Int]
    private var currentArray: [Int] = []
    
    init(isMax: Bool, input: [Int]) {
        self.isMax = isMax
        self.input = input
    }
    
    var output: [Int] {
        for element in input {
            currentArray.append(element)
            swapIfNeeded(index: currentArray.count - 1)

        }
        return currentArray
    }
    
    func swapIfNeeded(index: Int) {
        if index == 0 { return }
        let parentIndex: Int = Int((index + 1) / 2) - 1
        let parentValue = currentArray[parentIndex]
        let currentValue = currentArray[index]
        if isNeedSwap(parent: parentValue, current: currentValue) {
            currentArray.swapAt(parentIndex, index)
            swapIfNeeded(index: parentIndex)
        } 
    }
    
    func isNeedSwap(parent: Int, current: Int) -> Bool {
        if isMax {
            return parent < current
        }
        return parent > current
    }
    
}


class Heap {
    static func solution(isMax: Bool, input: Array<Int>) -> Array<Int> {
        let heap = HeapTree(isMax: isMax, input: input)
        return heap.output
    }
}


class HeapTests: XCTestCase {

    func testMinHeap() {
        let input = [5, 1, 4, 2, 3]
        let output = [1, 2, 4, 5, 3]

        XCTAssertEqual(Heap.solution(isMax: false, input: input), output)
    }
    
    func testMinPoll() {
//        let input = [5, 1, 4, 2, 3]
//        let output = [1, 2, 4, 5, 3]
//
    }
}

HeapTests.defaultTestSuite.run()
