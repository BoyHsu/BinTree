//
//  RedBlack.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/19.
//

import Foundation

class RedBlack<T: Comparable>: BST<T> {
    override func updateHeight(_ x: BinNode<T>) {
        x.rb_updateHeight()
    }
    
    override func insert(_ e: T) -> BinNode<T> {
        if let x = search(e) {
            return x
        }
        
        let x = BinNode(data: e, parent: _hot)
        size += 1
        solveDoubleRed(x)
        
        return x
    }
    
    /**
     解决双红问题
     RR-1，叔叔节点不存在，或者叔叔节点是黑节点
     RR-2，叔叔节点是红节点
     
     RR-1
            ┌───g─┐                 ┌─g─────┐
        ┌─p(R)─┐        u(B)             u(B)             ┌─p(R)─┐
     ┌─x(R)─┐    x2                                     ┌─x(R)─┐      x2
     x0             x1                                             x0             x1
     before
     x0, x1, x2, u是等高的，设为h
     则x.height == p.height == g.height == h
     在x点进行connect34旋转
        ┌──  b(B)  ──┐
     ┌─a(R)─┐      ┌─c(R)─┐
     x0             x1     x2               u
     g一定是a或者c，所以g一定是红色
     x、p同侧，p将是b，为黑节点，不同侧，x是b
     旋转后恢复平衡
     
     RR-2
            ┌───g───┐
        ┌─p(R)─┐        ┌─u(R)─┐
     ┌─x(R)─┐    x2       x3             x4
     x0             x1
     
     x0.height = x1.height = x2.height = x3.height = x4.height = h
     x.height = p.height = u.height = h
     g.height = h + 1
     
     将p、u染成黑色，g染成红色
     p.height = u.height = g.height = h+1
     g变成红色之后可能会有双红问题，递归调用
     */
    func solveDoubleRed(_ x: BinNode<T>) {
        guard let p = x.parent else {
            root?.color = .black
            root?.height += 1
            return
        }
        
        if p.color == .black {
            return
        }
        
        guard let g = p.parent else {
            return
        }
        let u = x.uncle
        if BinNode.isBlack(u) {//RR-1: 叔叔节点颜色为黑 或者不存在叔叔节点
            if x.isLeftChild == p.isLeftChild {// x、p同侧，p将成为 x、g两个红节点的父亲
                p.color = .black
            } else { // 不同侧，x成为父亲
                x.color = .black
            }
            g.color = .red
            _ = rotate(at: x)
        } else {
            p.color = .black
            p.height += 1
            u?.color = .black
            u?.height += 1
            g.color = .red
            solveDoubleRed(g)
        }
    }
    
    override func remove(_ e: T) -> Bool {
        guard let x = search(e) else { return false }
        let r = remove(at: x)
        size -= 1
        if size == 0 {
            return true
        }
        if _hot == nil, let root = root {
            root.color = .black
            updateHeight(root)
            return true
        }
        if _hot.blackHeightUpdated() {
            return true
        }
        
        if !BinNode.isBlack(r) {
            r?.color = .black
            r?.height += 1
            return true
        } else {
            solveDoubleBlack(r)
            return true
        }
    }
    
    func solveDoubleBlack(_ r: BinNode<T>?) {
        guard let p = r?.parent ?? _hot, let s = p.left === r ? p.right : p.left else { return }
        
        if s.isBlack {
            var t: BinNode<T>? = nil
            if s.left?.isRed == true {
                t = s.left
            }
            if s.right?.isRed == true {
                t = s.right
            }
            
            if let t = t {// BB-1
                let color = p.color
                if let b = rotate(at: t) {
                    b.left?.color = .black
                    b.left?.rb_updateHeight()
                    b.right?.color = .black
                    b.right?.rb_updateHeight()
                    b.color = color
                    updateHeight(b)
                }
            } else {// BB-2R or BB-2B
                s.color = .red
                s.height -= 1
                if p.color == .red {
                    p.color = .black
                } else {
                    p.height -= 1
                    solveDoubleBlack(p)
                }
            }
        } else {// BB-3
            s.color = .black
            p.color = .red
            if let t = s.isLeftChild ? s.left : s.right {
                _hot = p
                _ = rotate(at: t)
                solveDoubleBlack(r)
            }
        }
    }
}

//MARK: - Seralization
extension RedBlack<Int> {
    /**
     "{#,2B,3R}"
                    2(B)
                      \
                      3(R)
     
     */
    convenience init?(_ str: String) {
        guard !str.isEmpty else { return nil }
        var str = str
        str.removeAll(where: { $0 == "{" || $0 == "}" })
        var nodes = [BinNode<Int>?]()
        
        for subStr in str.split(separator: ",") {
            if subStr == "#" {
                nodes.append(nil)
            } else {
                let lastIdx = subStr.index(before: subStr.endIndex)
                let node = BinNode(data: Int(subStr[subStr.startIndex..<lastIdx])!)
                node.color = subStr[lastIdx] == "R" ? .red : .black
                nodes.append(node)
            }
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
        
        self.init()
        _ = attachAsRoot(nodes.first!!)
    }
}

extension RedBlack<Int>? {
    func serialize() -> String {
        guard let root = self?.root else { return "" }
        var queue = [root]
        var res = "{"
        var curLevel = "\(root.data)\(root.color == .red ? "R" : "B")"
        while !queue.isEmpty {
            res.append(contentsOf: curLevel)
            curLevel.removeAll(keepingCapacity: true)
            var nextLevel = [BinNode<Int>]()
            for node in queue {
                if let l = node.left {
                    nextLevel.append(l)
                    curLevel.append(",\(l.data)\(l.color == .red ? "R" : "B")")
                } else {
                    curLevel.append(",#")
                }
                if let r = node.right {
                    nextLevel.append(r)
                    curLevel.append(",\(r.data)\(r.color == .red ? "R" : "B")")
                } else {
                    curLevel.append(",#")
                }
            }
            queue = nextLevel
        }
        while res.last == "#" || res.last == "," {
            res.removeLast()
        }
        res.append("}")
        return res
    }
}
