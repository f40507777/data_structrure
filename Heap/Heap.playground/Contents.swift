import UIKit
import XCTest

class Heap {
    private let isMax: Bool
    private let input: [Int]
    private var currentArray: [Int] = []
    
    init(isMax: Bool, input: [Int]) {
        self.isMax = isMax
        self.input = input
        update()
    }
    
    var output: [Int] {
        return currentArray
    }
    
    var poll: Int? {
        let rootValue = currentArray.first
        lastValueToFirstValue()
        bubbleDown(0)
        return rootValue
    }
 
}

extension Heap {
    private func maybeValue(_ index: Int) -> Int? {
        return index > currentArray.count - 1 ? nil : currentArray[index]
    }
    
    private func compareIndex(leftIndex: Int, rightIndex: Int) -> Int? {
        if let left = maybeValue(leftIndex) {
            if let right = maybeValue(rightIndex) {
                if isMax {
                    if right > left {
                        return right
                    }
                } else {
                    if right < left {
                        return right
                    }
                }
                
                return leftIndex
            }
        } else if maybeValue(rightIndex) != nil {
            return rightIndex
        }

        return nil
    }

}

extension Heap {
    private func lastValueToFirstValue() {
        guard let last = currentArray.last else { return }
        currentArray[0] = last
    }
    
    private func bubbleDown(_ index: Int) {
        let currentValue = currentArray[index]
        let leftChildIndex = (index * 2) + 1
        let rightChildIndex = (index * 2) + 2
        guard let childIndex = compareIndex(leftIndex: leftChildIndex, rightIndex: rightChildIndex) else { return }
        if (isMax && currentArray[childIndex] > currentValue) ||
            (!isMax && currentArray[childIndex] < currentValue) {
            currentArray.swapAt(childIndex, index)
            bubbleDown(childIndex)
        }


    }

}

extension Heap {
    private func update() {
        for element in input {
            currentArray.append(element)
            swapIfNeeded(index: currentArray.count - 1)
        }
    }

    private func swapIfNeeded(index: Int) {
        if index == 0 { return }
        let parentIndex: Int = Int((index + 1) / 2) - 1
        let parentValue = currentArray[parentIndex]
        let currentValue = currentArray[index]
        if isNeedSwap(parent: parentValue, current: currentValue) {
            currentArray.swapAt(parentIndex, index)
            swapIfNeeded(index: parentIndex)
        }
    }
    
    private func isNeedSwap(parent: Int, current: Int) -> Bool {
        if isMax  {
            return parent < current
        }
        return parent > current
    }
}

class HeapTests: XCTestCase {

    func testMinHeap() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: false, input: input)
        XCTAssertEqual(heap.output, [1, 2, 4, 5, 3])
    }
    
    func testMaxHeap() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: true, input: input)
        XCTAssertEqual(heap.output, [5, 3, 4, 1, 2])
    }
    
    func testMinPoll() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: false, input: input)
        XCTAssertEqual(heap.poll, 1)
    }
    
    func testMaxPoll() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: true, input: input)
        XCTAssertEqual(heap.poll, 5)
    }
}


HeapTests.defaultTestSuite.run()
