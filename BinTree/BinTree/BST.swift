//
//  BST.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/17.
//

import Foundation

class BST<T: Comparable>: BinTree<T> {
    func search(_ e: T) -> BinNode<T>? {
        return Self.search(in: root, e, &_hot)
    }
    
    func insert(_ e: T) -> BinNode<T> {
        if let x = search(e) {
            return x
        }
        let x = BinNode(data: e)
        if _hot.data > x.data {
            _hot.left = x
        } else {
            _hot.right = x
        }
        size += 1
        updateHeightAbove(x)
        
        return x
    }
    
    func remove(_ e: T) -> Bool {
        guard let x = search(e) else {
            return false
        }
    
        let res = remove(at: x)
        size -= 1
        if let res = res {
            updateHeightAbove(res)
        }
        return true
    }
    
    private var _hot: BinNode<T>!
    func connect34(_ a: BinNode<T>, _ b: BinNode<T>, _ c: BinNode<T>, _ x0: BinNode<T>?, _ x1: BinNode<T>?, _ x2 : BinNode<T>?, _ x3: BinNode<T>?) -> BinNode<T> {
        a.left = x0
        a.right = x1
        a.updateHeight()
        
        c.left = x2
        c.right = x3
        c.updateHeight()
        
        b.left = a
        b.right = c
        b.updateHeight()
        
        return b
    }
    func rotate(at x: BinNode<T>) -> BinNode<T>? {
        guard let p = x.parent, let g = p.parent else {
            return nil
        }
        
        if p.isLeftChild {// zig
            if x.isLeftChild {// zig zig
                replace(g, with: p)
                return connect34(x, p, g, x.left, x.right, p.right, g.right)
            } else {// zig zag
                replace(g, with: x)
                return connect34(p, x, g, p.left, x.left, x.right, g.right)
            }
        } else {// zag
            if x.isLeftChild {// zag zig
                replace(g, with: x)
                return connect34(g, x, p, g.left, x.left, x.right, p.right)
            } else {// zag zag
                replace(g, with: p)
                return connect34(g, p, x, g.left, p.left, x.left, x.right)
            }
        }
    }
    
    
    static func search(in x: BinNode<T>?, _ e: T, _ hot: inout BinNode<T>?) -> BinNode<T>? {
        if x == nil || x!.data == e {
            return x
        }
        hot = x
        return search(in: x!.data > e ? x?.left : x?.right, e, &hot)
    }
    
    func replace(_ x: BinNode<T>, with succ: BinNode<T>?) {
        if let p = x.parent {
            if p.left === x {
                p.left = succ
            } else {
                p.right = succ
            }
        } else {
            root = succ
        }
    }
    
    func remove(at x: BinNode<T>) -> BinNode<T>? {
        var w: BinNode<T>? = x
        var succ: BinNode<T>? = nil
        if !w!.hasLeftChild {
            succ = w!.right
            replace(x, with: succ)
        } else if !w!.hasRightChild {
            succ = w!.left
            replace(x, with: succ)
        } else {
            w = w?.succ()
            x.data = w!.data
            let u = w?.parent
            succ = w
            if u === x {
                u?.right = w?.right
            } else {
                u?.left = w?.right
            }
        }
        
        succ?.parent = w?.parent
        
        return succ
    }
}
