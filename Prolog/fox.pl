goal([[0, 1, 2], [3, 4, 5], [6, 7, 8]]).

tah(S, NewState) :-
    append(BeforeLines, [Line | AfterLines], S),
    append(Before, [0, X | After], Line),
    append(Before, [X, 0 | After], NewLine),
    append(BeforeLines, [NewLine | AfterLines], NewState).

tah(S, NewState) :-
    append(BeforeLines, [Line | AfterLines], S),
    append(Before, [X, 0 | After], Line),
    append(Before, [0, X | After], NewLine),
    append(BeforeLines, [NewLine | AfterLines], NewState).

tah(S, NewState) :-
    append(LinesBefore, [Line1, Line2 | LinesAfter], S),
    append(Before1, [0 | After1], Line1),
    append(Before2, [X | After2], Line2),
    length(Before1, L), length(Before2, L),
    append(Before1, [X | After1], NewLine1),
    append(Before2, [0 | After2], NewLine2),
    append(LinesBefore, [NewLine1, NewLine2 | LinesAfter], NewState).

tah(S, NewState) :-
    append(LinesBefore, [Line1, Line2 | LinesAfter], S),
    append(Before1, [X | After1], Line1),
    append(Before2, [0 | After2], Line2),
    length(Before1, L), length(Before2, L),
    append(Before1, [0 | After1], NewLine1),
    append(Before2, [X | After2], NewLine2),
    append(LinesBefore, [NewLine1, NewLine2 | LinesAfter], NewState).

solve(Start, N) :-
    goal(G),
    empty_assoc(Empty),
    put_assoc(Start, Empty, root, Visited),
    bfs([[Start, 0]], G, Visited, N).

bfs([[G, N] | _], G, Visited, N) :-
    reconstruct_path(G, Visited, Path),
    reverse(Path, ForwardPath),
    print_path(ForwardPath),
    !.

bfs([[Current, D] | RestQueue], G, Visited, N) :-
    findall(Next, tah(Current, Next), Neighbors),
    exclude(visited(Visited), Neighbors, Unvisited),
    add_visited(Unvisited, Current, Visited, NewVisited),
    NextD is D + 1,
    findall([U, NextD], member(U, Unvisited), NewItems),
    append(RestQueue, NewItems, NewQueue),
    bfs(NewQueue, G, NewVisited, N).

visited(As, S) :- get_assoc(S, As, _).

add_visited([], _, As, As).
add_visited([S|T], Parent, As, Bs) :-
    put_assoc(S, As, Parent, Cs),
    add_visited(T, Parent, Cs, Bs).

reconstruct_path(root, _, []) :- !.
reconstruct_path(State, Visited, [State | Path]) :-
    get_assoc(State, Visited, Parent),
    reconstruct_path(Parent, Visited, Path).

print_path([]).
print_path([Stav | Rest]) :-
    print_matrix(Stav),
    nl,
    print_path(Rest).

print_matrix([]).
print_matrix([Row | Rest]) :-
    print_row(Row),
    nl,
    print_matrix(Rest).

print_row([]).
print_row([Num | Rest]) :-
    write(Num), write(' '),
    print_row(Rest).