man(david).
man(thomas).

woman(stella).
woman(emma).

across(X, Y) :-
    (man(X), man(Y));
    (woman(X), woman(Y)), 
    X \= Y.

unique(A, B, C, D) :- 
    A \= B,
    A \= C,
    A \= D,
    B \= C,
    B \= D,
    C \= D.

hasPerson(X) :-
    X = stella;
    X = emma;
    X = david;
    X = thomas.

solve(Dumplings, Pasta, Soup, Trout) :-
    hasPerson(Dumplings),
    hasPerson(Pasta),
    hasPerson(Soup),
    hasPerson(Trout),

    hasPerson(Cider),
    hasPerson(Beer),
    hasPerson(Tea),
    hasPerson(Wine),

    unique(Dumplings, Pasta, Soup, Trout),
    unique(Cider, Beer, Tea, Wine),

    across(Cider, Trout),
    Dumplings = Beer,
    Soup = Cider,
    across(Pasta, Beer),
    Tea \= david,
    Wine = emma,
    Dumplings \= stella.
