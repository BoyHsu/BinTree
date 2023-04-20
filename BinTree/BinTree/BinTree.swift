//
//  BinTree.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/15.
//

import Foundation

class BinTree<T: Comparable> {
    var size = 0
    var root: BinNode<T>? = nil
    
    func updateHeight(_ x: BinNode<T>) {
        x.updateHeight()
    }
    
    func updateHeightAbove(_ x: BinNode<T>) {
        var x: BinNode<T>? = x
        while x !== nil {
            updateHeight(x!)
            x = x?.parent
        }
    }
    
    func updateHeightBelow(_ x: BinNode<T>?) {
        if x == nil {
            return
        }
        updateHeightBelow(x?.left)
        updateHeightBelow(x?.right)
        updateHeight(x!)
    }
    
    func empty() -> Bool {
        return root == nil
    }
    
    func insertAsRoot(_ e: T) -> BinNode<T> {
        size = 1
        root = BinNode(data: e)
        return root!
    }
    
    func insertAsLeftChild(_ x: BinNode<T>, e: T) -> BinNode<T> {
        _ = x.insertAsLeftChild(e)
        updateHeightAbove(x)
        size += 1
        return x.left!
    }
    
    func insertAsRightChild(_ x: BinNode<T>, e: T) -> BinNode<T> {
        _ = x.insertAsRightChild(e)
        updateHeightAbove(x)
        size += 1
        return x.right!
    }
    
    func attachAsRoot(_ x: BinNode<T>) -> BinNode<T> {
        root = x
        size = x.size()
        updateHeightBelow(x)
        
        return root!
    }
    
    func attachAsLeftChild(_ x: BinNode<T>, e: BinTree) -> BinNode<T> {
        if x.left != nil {
            size -= 1
        }
        x.left = e.root
        x.left?.parent = x
        size += e.size
        updateHeightAbove(x)
        return x
    }
    
    func attachAsRightChild(_ x: BinNode<T>, e: BinTree) -> BinNode<T> {
        if x.right != nil {
            size -= 1
        }
        x.right = e.root
        size += e.size
        updateHeightAbove(x)
        return x
    }
    
    func remove(_ x: BinNode<T>) -> Int {
        x.removeFromParent()
        size -= x.size()
        return size
    }
    
    func secede(_ x: BinNode<T>) -> BinTree {
        _ = remove(x)
        let tree = BinTree()
        tree.root = x
        tree.size = x.size()
        return tree
    }
    
    func travPre(_ visit: BinNode<T>.VST) {
        root?.travPre(visit)
    }
    
    func travIn(_ visit: BinNode<T>.VST) {
        root?.travIn(visit)
    }
    
    func travPost(_ visit: BinNode<T>.VST) {
        root?.travPost(visit)
    }
    
}
