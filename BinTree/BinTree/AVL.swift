//
//  AVL.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/17.
//

import Foundation

class AVL<T: Comparable>: BST<T> {
    override func insert(_ e: T) -> BinNode<T> {
        if let x = search(e) {
            return x
        }
        
        let x = BinNode(data: e, parent: _hot)
        size += 1
        var g = _hot
        while g != nil {
            if g!.AVLBalanced == true {
                updateHeight(g!)
            } else {
                _ = rotate(at: g!.tallerChild!.tallerChild!)
            }
            g = g?.parent
        }
        return x
    }
    
    override func remove(_ e: T) -> Bool {
        guard let x = search(e) else { return false }
        
        _ = remove(at: x)
        size -= 1
        
        var g = _hot
        while g != nil {
            if g?.AVLBalanced == false {
                _ = rotate(at: g!.tallerChild!.tallerChild!)
            }
            updateHeight(g!)
            g = g?.parent
        }
        return true
    }
}

extension BinNode {
    var balFac: Int {
        return BinNode.stature(self.left) - BinNode.stature(self.right)
    }
    
    var AVLBalanced: Bool {
        let absBalFac = abs(balFac)
        return absBalFac < 2
    }
    
    var tallerChild: BinNode? {
        let balFacL = BinNode.stature(self.left)
        let balFacR = BinNode.stature(self.right)
        
        if balFacL > balFacR {
            return self.left
        } else if balFacL < balFacR {
            return self.right
        } else {
            return isLeftChild ? self.left : self.right
        }
    }
}
