//
//  main.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/15.
//

import Foundation

for (before, deleteVal, after) in [
    ("", 4, ""),
    ("{4,2,6,1,3,5,7}", 4, "{5,2,6,1,3,#,7}"),// 满树
    ("{36,27,58,6,#,53,#,#,#,40,#,#,46}", 36, "{40,27,58,6,#,53,#,#,#,46}"),//左右子树
    ("{4,2,#,1}", 4, "{2,1}"),//左子树
    ("{4,#,6,5}", 4, "{6,5}"),//右子树
] {
    if let node = BinNode(before) {
        let bt = BST<Int>()
        _ = bt.attachAsRoot(node)
        _ = bt.remove(deleteVal)
        assert(bt.root.serialize() == after)
    }
}

for (before, val, after) in [
("{36,27,58,6,#,53,#,#,#,40,#,#,46}", 46, "{36,27,58,6,#,46,#,#,#,40,53}"),// zig-zag
("{36,27,58,6,#,53,#,#,#,40,#,#,46}", 6, "{27,6,36,#,#,#,58,53,#,40,#,#,46}"),// zig-zig
("{36,27,58,6,#,53,#,#,#,40,#,#,46}", 53, "{53,36,58,27,40,#,#,6,#,#,46}"),// zag-zig
("{1,#,2,#,3}", 3, "{2,1,3}"), // zag-zag
] {
    if let node = BinNode(before) {
        let bt = BST<Int>()
        _ = bt.attachAsRoot(node)
        if let x = bt.search(val) {
            _ = bt.rotate(at: x)
            assert(bt.root.serialize() == after)
        } else {
            assert(false)
        }
    }
}

for (before, val, after) in [
("{4,2,6}", 5, "{4,2,6,#,#,5}"),
("{4,2,6,1,3,5,7}", 8, "{4,2,6,1,3,5,7,#,#,#,#,#,#,#,8}"),
("{4,2,6,1,3,5,7}", 0, "{4,2,6,1,3,5,7,0}"),
] {
    if let node = BinNode(before) {
        let bt = BST<Int>()
        _ = bt.attachAsRoot(node)
        _ = bt.insert(val)
        assert(bt.root.serialize() == after)
    } else {
        assert(false)
    }
}

for (before, val, after) in [
    ("{2}", 1, "{2,1}"),
    ("{2}", 3, "{2,#,3}"),
    ("{4,2,6,1,#,#,7}", 9, "{4,2,7,1,#,6,9}"),
    ("{4,2,6,1,#,5,7}", 9, "{4,2,6,1,#,5,7,#,#,#,#,#,9}"),
    ("{4,2,6,#,#,5,7}", 9, "{6,4,7,2,5,#,9}"),
] {
    let avl = AVL<Int>()
    _ = avl.attachAsRoot(BinNode(before)!)
    _ = avl.insert(val)
    assert(avl.root.serialize() == after)
}

for (before, val, after) in [
    ("{4,2,7,1,#,6,9}", 9, "{4,2,7,1,#,6}"),
    ("{4,2,6,1,#,5,7,#,#,#,#,#,9}", 9, "{4,2,6,1,#,5,7}"),
    ("{6,4,7,2,5,#,9,1}", 9, "{4,2,6,1,#,5,7}"),
    ("{40,25,65,12,30,45,70,10,20,27,#,42,47,67,80,8,#,#,#,#,#,41,#,#,#,66,#,75,85,#,#,#,#,#,#,#,77}", 27, "{65,40,70,12,45,67,80,10,25,42,47,66,#,75,85,8,#,20,30,41,#,#,#,#,#,#,77}"),
] {
    let avl = AVL<Int>()
    _ = avl.attachAsRoot(BinNode(before)!)
    _ = avl.remove(val)
    assert(avl.root.serialize() == after)
}

print("done")
