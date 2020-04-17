import UIKit
import XCTest

class Heap {
    private let isMax: Bool
    private let input: [Int]
    var currentArray: [Int] = []
    
    init(isMax: Bool, input: [Int]) {
        self.isMax = isMax
        self.input = input
        update()
    }
    
    var output: [Int] {
        return currentArray
    }
    
    var poll: Int? {
        guard let rootValue = currentArray.first else { return nil }
        lastValueToFirstValue()
        currentArray.removeLast()
        bubbleDown(0)
        return rootValue
    }
    
    func insert(_ value: Int) {
        currentArray.append(value)
        bubbleUp(currentArray.count - 1)
    }
    
    func remove(_ value: Int) {
        guard let last = currentArray.last else { return }
        if value == last {
            currentArray.removeLast()
            return
        }
        
        guard let targetIndex = currentArray.firstIndex(of: value) else { return }
        currentArray[targetIndex] = last
        currentArray.removeLast()
        
        let parentIndex: Int = getParentIndex(targetIndex)
        if parentIndex > 0, (currentArray[parentIndex] < currentArray[targetIndex]) == isMax {
            bubbleUp(targetIndex)
        } else {
            bubbleDown(targetIndex)
        }

    }
 
}

extension Heap {

    private func bubbleUp(_ index: Int) {
        if index == 0 { return }
        let parentIndex: Int = getParentIndex(index)
        let parentValue = currentArray[parentIndex]
        let currentValue = currentArray[index]
        if isNeedSwap(parent: parentValue, child: currentValue) {
            currentArray.swapAt(parentIndex, index)
            bubbleUp(parentIndex)
        }
    }
    
    private func bubbleDown(_ index: Int) {
        if currentArray.count == 0 { return }
        let currentValue = currentArray[index]
        let leftChildIndex = getLeftChildIndex(index)
        let rightChildIndex = getRightChildIndex(index)
        guard let childIndex = compareIndex(leftIndex: leftChildIndex, rightIndex: rightChildIndex) else { return }
        let childValue = currentArray[childIndex]
        if isNeedSwap(parent: currentValue, child: childValue) {
            currentArray.swapAt(childIndex, index)
            bubbleDown(childIndex)
        }
    }
    
    private func isNeedSwap(parent: Int, child: Int) -> Bool {
        return isMax != (parent > child)
    }
    
    private func getParentIndex(_ index: Int) -> Int {
        return Int((index + 1) / 2) - 1
    }
    
    private func getLeftChildIndex(_ index: Int) -> Int {
        return (index * 2) + 1
    }
    
    private func getRightChildIndex(_ index: Int) -> Int {
        return getLeftChildIndex(index) + 1
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
                        return rightIndex
                    }
                } else {
                    if right < left {
                        return rightIndex
                    }
                }
            }
            return leftIndex
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
    
}

extension Heap {
    private func update() {
        for value in input {
            insert(value)
        }
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

    func testMinInsert() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: false, input: input)
        heap.insert(0)
        XCTAssertEqual(heap.currentArray, [0, 2, 1, 5, 3, 4])
    }
    
    func testMaxInsert() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: true, input: input)
        heap.insert(9)
        heap.currentArray
        XCTAssertEqual(heap.currentArray, [9, 3, 5, 1, 2, 4])
    }
    
    func testMinRemove() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: false, input: input)
        heap.remove(4)
        XCTAssertEqual(heap.currentArray, [1, 2, 3, 5])
        heap.remove(5)
        XCTAssertEqual(heap.currentArray, [1, 2, 3])
        heap.currentArray
        heap.remove(1)
        XCTAssertEqual(heap.currentArray, [2, 3])
    }
    
    func testMaxRemove() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: true, input: input)
        heap.remove(4)
        XCTAssertEqual(heap.currentArray, [5, 3, 2, 1])
        heap.remove(3)
        XCTAssertEqual(heap.currentArray, [5, 1, 2])
        heap.remove(5)
        XCTAssertEqual(heap.currentArray, [2, 1])
        heap.remove(2)
        XCTAssertEqual(heap.currentArray, [1])
        heap.remove(1)
        XCTAssertEqual(heap.currentArray, [])

    }
    
    func testRemoveNotExist() {
        let input = [5, 1, 4, 2, 3]
        let heap = Heap(isMax: true, input: input)
        heap.remove(33333)
        XCTAssertEqual(heap.currentArray, [5, 3, 4, 1, 2])
    }
    
    func testOverPoll() {
        let input = [2, 3]
        let heap = Heap(isMax: true, input: input)
        heap.poll
        XCTAssertEqual(heap.currentArray, [2])
        heap.poll
        XCTAssertEqual(heap.currentArray, [])
        heap.poll
        XCTAssertEqual(heap.currentArray, [])
    }
}


HeapTests.defaultTestSuite.run()
