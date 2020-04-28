import UIKit
import XCTest


class Node<T: Equatable> {
  var value: T? = nil
  var next: Node? = nil
}

class LinkedList<T: Equatable> {
  var head = Node<T>()
}

class KeyValue: Equatable {
    var key: String = ""
    var value: String = ""
    init(key: String, value: String) {
        self.key = key
        self.value = value
    }
    static func == (lhs: KeyValue, rhs: KeyValue) -> Bool {
        return lhs.key == rhs.key && lhs.value == rhs.value
    }
}




extension String {
    var ascIISum: UInt32 {
        return self.unicodeScalars.map { $0.value }.reduce(0, +)
    }
}


protocol HashMapProtocol {
    func get(_ key: String) -> String?
    func set(key: String, value: String)
}

class HashMap {
    static let Mod = 256
    static func mod(_ input: String) -> Int {
        return Int(input.ascIISum) % Int(HashMap.Mod)
    }
}

class HashMapNextSlot {
    private var array = Array<KeyValue?>(repeating: nil, count: HashMap.Mod)
    
}

extension HashMapNextSlot: HashMapProtocol {
    func get(_ key: String) -> String? {
        var isStop = false
        var currentIndex = HashMap.mod(key)
        while !isStop {
            if currentIndex > HashMap.Mod { return nil }
            guard let target = array[currentIndex] else { return nil }
            if target.key == key {
                isStop = true
                return target.value
            }
            currentIndex = currentIndex + 1
         }
    }
    
    func set(key: String, value: String) {
        var isStop = false
        var currentIndex = HashMap.mod(key)
        while !isStop {
            if currentIndex > HashMap.Mod { return }
            guard let target = array[currentIndex] else {
                array[currentIndex] = KeyValue(key: key, value: value)
                isStop = true
                break
            }
            if target.key == key {
                target.value = value
                isStop = true
                break
            }
            currentIndex = currentIndex + 1
        }
        
    }
        
    
}



class HashMapLinkList {
    private var array = Array<LinkedList<KeyValue>?>(repeating: nil, count: HashMap.Mod)
    
    private func find(key: String, node: Node<KeyValue>) -> KeyValue? {
        guard let nodeValue = node.value else { return nil }
        if nodeValue.key == key { return nodeValue }
        guard let nextNode = node.next else { return nil }
        return find(key: key, node: nextNode)
    }
    
    private func findEndNode(_ node: Node<KeyValue>) -> Node<KeyValue> {
        guard let nextNode = node.next else { return node }
        return findEndNode(nextNode)
    }
}

extension HashMapLinkList: HashMapProtocol {
    func get(_ key: String) -> String? {
        let keyMod = HashMap.mod(key)
        guard let linklist = array[keyMod] else { return nil }
        guard let targetKeyValue = find(key: key, node: linklist.head) else { return nil }
        
        return targetKeyValue.value
    }
    
    func set(key: String, value: String) {
        let keyMod = HashMap.mod(key)
        guard let linklist = array[keyMod] else {
            let linkList = LinkedList<KeyValue>()
            let keyValue = KeyValue(key: key, value: value)
            linkList.head.value = keyValue
            array[keyMod] = linkList
            return
        }
        
        guard let findedKeyValue = find(key: key, node: linklist.head) else {
            let endNode = findEndNode(linklist.head)
            let newNode = Node<KeyValue>()
            newNode.value = KeyValue(key: key, value: value)
            endNode.next = newNode
            return
        }
        
        findedKeyValue.value = value
    }
    
}

class HashMapTests: XCTestCase {
    var hashMap: HashMapProtocol!
    override func setUp() {
//        hashMap = HashMapLinkList()
        hashMap = HashMapNextSlot()
    }
    
    func testSetAndGet() {
        hashMap.set(key: "ab", value: "Finn")
        hashMap.set(key: "ba", value: "Lex")
        hashMap.set(key: "a", value: "Jimmy")
        hashMap.set(key: "1", value: "Bob")
        hashMap.set(key: "AB", value: "Chuck")

        XCTAssertEqual(hashMap.get("ab"), "Finn")
        XCTAssertEqual(hashMap.get("ba"), "Lex")
        XCTAssertEqual(hashMap.get("a"), "Jimmy")
        XCTAssertEqual(hashMap.get("1"), "Bob")
        XCTAssertEqual(hashMap.get("AB"), "Chuck")

    }
    
    func testCollision() {
        hashMap.set(key: "abc", value: "Finn")
        hashMap.set(key: "bac", value: "Lex")
        hashMap.set(key: "cba", value: "Cuhck")

        XCTAssertEqual(hashMap.get("abc"), "Finn")
        XCTAssertEqual(hashMap.get("bac"), "Lex")
        XCTAssertEqual(hashMap.get("cba"), "Cuhck")

    }
    
    func testGetEmpty() {
        XCTAssertEqual(hashMap.get("ba"), nil)
    }
    
}

HashMapTests.defaultTestSuite.run()

