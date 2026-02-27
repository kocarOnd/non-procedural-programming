/*Task: Write the three predicates below. Your predicates should work 
correctly in every direction, and should always terminate when the 
solution set is finite.

a) Write a predicate sublist(L, M) that is true if M is a sublist of L, 
i.e. the elements of M appear contiguously somewhere inside L. 
A sublist must always contain at least one element. 

b) Write a predicate subseq(L, M) that is true if M is a subsequence of L, 
i.e. the elements of M appear in the same order inside L, but not necessarily 
contiguously. A subsequence may be empty. 

c) Write a predicate disjoint(L, M, N) that is true if M and N are disjoint 
subsequences of L. This means that M and N must be subsequences (as defined 
in part (b) above) and that M and N together must contain all the elements 
of L. For simplicity, you may assume that all elements of L are distinct.
*/

sublist(L, M) :-
    append(_, Y, L), append(A, _, Y), A = M, M \= [].

subseq(_, []).
subseq([X | R1], [X | R2]) :- 
    subseq(R1, R2).
subseq([_ | R1], [Y | R2]) :- 
    subseq(R1, [Y | R2]).

disjoint([], [], []).
disjoint([X | R1], [X | R2], Y) :-
    disjoint(R1, R2, Y).
disjoint([X | R1], Y, [X | R2]) :-
    disjoint(R1, Y, R2).    
