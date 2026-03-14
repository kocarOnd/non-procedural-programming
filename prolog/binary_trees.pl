/*Task: a) Construct a higher-order predicate maptree/2 that applies the given 
predicate P to the vertices of a binary tree:

maptree(+P, ?T) :- succeeds if the call of the (unary) predicate P on the argument 
V succeeds for every vertex V of the tree T.

Hint: Take inspiration from the definition of the maplist predicate in the lecture. 
In particular, you can use the built-in call predicate, which applies the given 
predicate P to the given argument.

b) Construct the predicate size(-T, +N, +H), which sequentially returns all binary 
trees T with N vertices and height H. The height of a tree is defined as the length 
of the longest path (measured by the number of edges) from the root to a leaf. 
For example, the tree b(nil, 10, t(nil, 15, nil)) has height 1. For an empty tree, 
we will assume a height of -1.

The predicate should generate all binary trees with the specified number of vertices 
N ≥ 0 and the specified height H ≥ -1. The vertices of the generated trees will 
contain free variables, which we can bind to specific values using the maptree 
predicate.*/

maptree(_, nil).

maptree(P, b(L, V, R)) :- 
    call(P, V), maptree(P, L), maptree(P, R).

size(nil, 0, -1).
size(b(L, _, R), N, D) :-
    New_N is N-1,
    between(0, New_N, X),
    Y is New_N-X,
    size(L, X, D1), size(R, Y, D2),
    D is max(D1, D2)+1.
    