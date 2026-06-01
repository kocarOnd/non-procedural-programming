/* Task: Write a Prolog predicate rotate(?L, ?M) that is true if L can be 
rotated by any number of positions (including zero) to form M. Your predicate 
should work in both directions.
*/

same_length([], []).
same_length([_|R1], [_|R2]) :- same_length(R1, R2).

rotate([], []).
rotate(L, M) :-
    same_length(L, M),
    append(X, [Y | R], L), append([Y | R], X, M).