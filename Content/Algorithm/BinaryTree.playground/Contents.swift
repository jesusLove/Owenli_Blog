//: Playground - noun: a place where people can play

import UIKit

//: 计算树的最大深度
func maxDepth(root: TreeNode?) -> Int {
    guard let root = root else { return 0 }
    return max(maxDepth(root: root.left), maxDepth(root: root.right)) + 1
}

//: 判断是否是二叉搜索树
func isValidBST(root: TreeNode?) -> Bool {
    return _helper(root, nil, nil)
}
private func _helper(_ node: TreeNode?, _ min: Int?, _ max: Int?) -> Bool {
    guard let node = node else { return true }
    // 所有右子树的节点值大于根节点
    if let min = min, node.val <= min {
        return false
    }
    // 所有左子树的节点值小于根节点
    if let max = max, node.val >= max {
        return false
    }
    return _helper(node.left, min, node.val) && _helper(node.right, node.val, max)
}

// MARK: 前序遍历

//: 前序遍历，递归实现
func preOrderTraversal_RE(root: TreeNode?) -> [Int] {
    var res = [Int]()
    _preHelper(root, &res)
    return res
}
// 辅助方法
func _preHelper(_ node: TreeNode?, _ res: inout [Int]) {
    guard let node = node else {return}
    res.append(node.val)
    _preHelper(node.left, &res)
    _preHelper(node.right, &res)
}
//: 前序遍历，使用栈
func preOrderTraversal(root: TreeNode?) -> [Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    while !stack.isEmpty || node != nil {
        if node != nil {
            res.append(node!.val)
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast().right
        }
    }
    return res
}

//: 中序遍历，递归实现
func inOrderTraversal_RE(root: TreeNode?) -> [Int] {
    var nums = [Int]()
    _inHelper(root, &nums)
    return nums
}
// 辅助方法
func _inHelper(_ node: TreeNode?, _ nums: inout [Int]) {
    guard let node = node else {return}
    _inHelper(node.left, &nums)
    nums.append(node.val)
    _inHelper(node.right, &nums)
}


//: 中序遍历, 非递归实现
func inOrderTraversal(root: TreeNode?) -> [Int] {
    var res = [Int]()
    var stack = [TreeNode]()
    var node = root
    while !stack.isEmpty || node != nil {
        if node != nil {
            stack.append(node!)
            node = node!.left
        } else {
            node = stack.removeLast()
            res.append(node!.val)
            node = node!.right
        }
    }
    
    return res
}



//: 后序遍历递归
func postOrderTraversal_RE(_ root: TreeNode?) -> [Int] {
    var nums = [Int]()
    _postHelper(root, &nums)
    return nums
}
func _postHelper(_ node: TreeNode?, _ nums:inout [Int]){
    guard let node = node else {return}
    _postHelper(node.left, &nums)
    _postHelper(node.right, &nums)
    nums.append(node.val)
}

//: 后序遍历
func postOrderTraversal(root: TreeNode?) -> [Int] {
    
    var res = [Int]()
    var stack = [TreeNode]()
    var tagStack = [Int]()
    var node = root
    
    while !stack.isEmpty || node != nil {
        
        while node != nil {
            stack.append(node!)
            tagStack.append(0)
            node = node!.left
        }
        while !stack.isEmpty && tagStack.last! == 1 {
            tagStack.removeLast()
            res.append(stack.removeLast().val)
        }
        // 访问左子树到头，访问右子树
        if !stack.isEmpty {
            tagStack.removeLast()
            tagStack.append(1)
            node = stack.last!.right
        }
    }
    return res
}

//: 层次遍历，广度优先遍历，需要使用队列
func levelOrder(root: TreeNode?) -> [[Int]] {
    var res = [[Int]]()
    var queue = [TreeNode]()
    if let root = root {
        queue.append(root)
    }
    while queue.count > 0 {
        let size = queue.count
        var level = [Int]()
        for _ in 0 ..< size {
            let node = queue.removeFirst()
            level.append(node.val)
            if let left = node.left {
                queue.append(left)
            }
            if let right = node.right {
                queue.append(right)
            }
        }
        res.append(level)
    }
    return res
}
