table(T) :- T =
    [
        1000 : [m], 900 : [c, m],
        500 : [d], 400 : [c, d],
        100 : [c], 90 : [x, c],
        50 : [l], 40 : [x, l],
        10 : [x], 9 : [i, x],
        5 : [v], 4 : [i, v],
        1 : [i]
    ].

convert(0, [], _).
# TODO: convert :- recursive calling

roman(N, R) :-
    between(0, 3999, N),
    table(T), 
    convert(N, R, T).
