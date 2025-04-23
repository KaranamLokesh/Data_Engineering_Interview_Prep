# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right

# the idea is to check if any subtree in root is equal to the subRoot, to do this, we check from root
# we have a helper function that takes in two trees and checks if they are equal or not, 
# if they are not equal we go to left and right subtree of the root tree and check if the subtree is in there

class Solution:   
    def check_tree(self, p,q):
        if not p and not q:
            return True
        if p and q and p.val == q.val:
            return self.check_tree(p.left, q.left) and self.check_tree(p.right, q.right)
        return False

    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        if not subRoot:
            return True
        if not root:
            return False
        if self.check_tree(root,subRoot):
            return True
        else:
            return self.isSubtree(root.left, subRoot) or self.isSubtree(root.right, subRoot)
        



        