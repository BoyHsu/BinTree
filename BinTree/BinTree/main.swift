//
//  main.swift
//  BinTree
//
//  Created by 徐恩 on 2023/4/15.
//

import Foundation

var root = BinNode("{4,2,6,1,3,5,7}")
root?.travPost({print($0)})
root = BinNode("{4,#,6,#,7}")
root?.travPost({print($0)})
