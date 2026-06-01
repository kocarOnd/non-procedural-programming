/*Task: Consider a simple variant of the Minesweeper game, in which the playing 
field contains only two rows. In Prolog, construct a predicate mines(Numbers, Mines) 
that succeeds if

    Numbers is a list of natural numbers representing the top row
    while the list Mines represents the bottom row, where the atom x denotes a mine 
    and the atom o denotes a square without a mine.

The predicate should work in both directions, i.e., for a given second row of Mines, 
it should return the corresponding first row of Numbers.

?- mines(Numbers, [o, x, o, x, o, o, x, o]).
Honor = [1, 1, 2, 1, 1, 1, 1, 1]

or, conversely, return the corresponding second row for a given first row:

?- mines([1, 1, 2, 1, 1, 1, 1, 1], Mines).
Mines = [o, x, o, x, o, o, x, o]

If there are multiple solutions, the predicate should return each one exactly once:

?- mines([1,1], Mines).
Mines = [o, x] ;
Mines = [x, o] 

The predicate should also work when the arguments contain both constants and 
free variables:

?- mines([A, 2, 1, B, 1, 1, 1, C, 1, 2, D], 
        [x, o, E, o, o, F, o, o, G, H, x]).
A = B, B = 1,
C = 0,
D = 2,
E = F, F = H, H = x,
G = o ;
A = B, B = C, C = D, D = 1,
E = F, F = G, G = x,
H = o 
*/

mine(x, 1).
mine(o, 0).

miny([], []).
miny(Pocty, Miny) :-
    same_length(Pocty, Miny),
    append([o], Miny, Temp), 
    append(Temp, [o], Result),
    recursive_mines(Pocty, Result).

recursive_mines([N], [M1, M2, M3]) :-
    mine(M1, N1), mine(M2, N2), mine(M3, N3),
    N is N1 + (N2 + N3).
recursive_mines([N|Rn], [M1, M2, M3 | Rm]) :-
    mine(M1, N1), mine(M2, N2), mine(M3, N3),
    N is N1 + (N2 + N3),
    recursive_mines(Rn, [M2, M3 | Rm]).
