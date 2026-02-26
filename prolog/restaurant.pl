/* Task: 
Write a Prolog program that can solve the following logic puzzle.

David, Emma, Stella, and Thomas were at a restaurant in Prague. 
They sat at a square table, with one person on each side, and the 
men sat across the table from each other, as did the women. 
Each of them ordered a different food along with a different beverage. 
Also:

    The person with cider sat across from the person with trout.
    The dumplings came with beer.
    The mushroom soup came with cider.
    The person with pasta sat across from the person with beer.
    David never drinks iced tea.
    Emma only drinks wine.
    Stella does not like dumplings.

Who ordered which food?

Your program should include a predicate 'solve' that takes four arguments. 
solve(Dumplings, Pasta, Soup, Trout) should return the names of the people 
who ordered each dish. Names are lowercase Prolog atoms. For example, 
if rule 7 above were absent, the output might begin like this:

?- solve(Dumplings, Pasta, Soup, Trout).
Dumplings = stella,
Pasta = emma,
Soup = david,
Trout = thomas ;
...

Of course, your output will be different, since with rule 7 the above output is not a valid solution.
 */

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
