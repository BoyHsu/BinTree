//
//  BinNode.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/15.
//

import Foundation

class BinNode<T> where T: Any {
    
    enum RBColor {
        case red, black
    }
    
    var data: T
    var parent: BinNode? = nil
    
    var left: BinNode? = nil {
        didSet {
            left?.parent = self
        }
    }
    
    var right: BinNode? = nil {
        didSet {
            right?.parent = self
        }
    }
    
    var height = 0
    var npl = 1
    var color = RBColor.red
    
    init(data: T, parent: BinNode? = nil, left: BinNode? = nil, right: BinNode? = nil, height: Int = 0, npl: Int = 1, color: RBColor = RBColor.red) {
        self.data = data
        self.parent = parent
        self.left = left
        self.right = right
        self.height = height
        self.npl = npl
        self.color = color
    }
    
    func updateHeight() {
        height = 1 + max(Self.stature(self.left), Self.stature(self.right))
    }
    
    func insertAsLeftChild(_ data: T) -> BinNode {
        let node = BinNode(data: data)
        self.left = node
        return node
    }
    
    func insertAsRightChild(_ data: T) -> BinNode {
        let node = BinNode(data: data)
        self.right = node
        return node
    }
    
    func succ() -> BinNode? {
        var node: BinNode? = self
        if let right = self.right {
            node = right
            while let left = node?.left {
                node = left
            }
        } else {
            while node?.isRightChild == true {
                node = node?.parent
            }
            node = node?.parent
        }
        return node
    }
    
    func size() -> Int {
        return (self.left?.size()) ?? 0 + (self.right?.size() ?? 0) + 1
    }
    
    typealias VST = (T)->Void
    
    func travPre(_ visit: VST) {
        var stack = [BinNode]()
        var node: BinNode? = self
        while true {
            while node != nil {
                visit(node!.data)
                if let righ = node?.right {
                    stack.append(righ)
                }
                node = node?.left
            }
            if stack.isEmpty {
                break
            }
            node = stack.popLast()
        }
    }
    
    func travIn(_ visit: VST) {
        var stack = [BinNode]()
        var node: BinNode? = self
        while true {
            while node != nil {
                stack.append(node!)
                node = node?.left
            }
            if stack.isEmpty {
                break
            }
            node = stack.popLast()
            visit(node!.data)
            node = node?.right
        }
    }
    
    func travPost(_ visit: VST) {
        var node: BinNode? = self
        var stack = [self]
        while !stack.isEmpty {
            let top = stack.last
            if node?.parent !== top {
                node = top
                while node?.hasChild == true {
                    if let right = node?.right {
                        stack.append(right)
                    }
                    
                    if let left = node?.left {
                        stack.append(left)
                    }
                    node = stack.last
                }
            }
            
            node = stack.popLast()
            visit(node!.data)
        }
    }
    
    func removeFromParent() {
        if isLeftChild {
            parent?.left = nil
        } else {
            parent?.right = nil
        }
        parent = nil
    }
    
    static func stature(_ x: BinNode?) -> Int {
        return x?.height ?? -1
    }
}

extension BinNode {
    var isRoot: Bool {
        return parent == nil
    }
    
    var isLeftChild: Bool {
        return parent?.left === self
    }
    
    var isRightChild: Bool {
        return parent?.right === self
    }
    
    var hasParent: Bool {
        return parent != nil
    }
    
    var hasLeftChild: Bool {
        return self.left != nil
    }
    
    var hasRightChild: Bool {
        return self.right != nil
    }
    
    var hasChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    var hasBothChild: Bool {
        return hasLeftChild && hasRightChild
    }
}

//MARK: - Seralization
extension BinNode<Int> {
    convenience init?(_ str: String) {
        guard !str.isEmpty else { return nil }
        var str = str
        str.remove(at: str.startIndex)
        str.remove(at: str.index(before: str.endIndex))
        var nodes = [BinNode?]()
        
        for subStr in str.split(separator: ",") {
            if let val = Int(subStr) {
                nodes.append(BinNode(data: val))
            } else if subStr == "#" {
                nodes.append(nil)
            }
        }
        if let root = nodes.first! {
            self.init(data: root.data)
            nodes[0] = self
        } else {
            return nil
        }
        var idxParent = 0, idxChild = 1
        let count = nodes.count
        while idxChild < count {
            if let node = nodes[idxParent] {
                node.left = nodes[idxChild]
                idxChild += 1
                if idxChild < count {
                    node.right = nodes[idxChild]
                    idxChild += 1
                }
            }
            idxParent += 1
        }
    }
}

extension BinNode<Int>? {
    func serialize() -> String {
        guard let root = self else { return "" }
        var queue = [root]
        var res = "{"
        var curLevel = "\(root.data)"
        while !queue.isEmpty {
            res.append(contentsOf: curLevel)
            curLevel.removeAll(keepingCapacity: true)
            var nextLevel = [BinNode<Int>]()
            for node in queue {
                if let l = node.left {
                    nextLevel.append(l)
                    curLevel.append(",\(l.data)")
                } else {
                    curLevel.append(",#")
                }
                if let r = node.right {
                    nextLevel.append(r)
                    curLevel.append(",\(r.data)")
                } else {
                    curLevel.append(",#")
                }
            }
            queue = nextLevel
        }
        while res.last?.isWholeNumber != true {
            res.removeLast()
        }
        res.append("}")
        return res
    }
}
