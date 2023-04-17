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

print("done")
