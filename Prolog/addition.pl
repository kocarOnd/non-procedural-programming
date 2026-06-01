/* Task: Let the Prolog atoms 'zero' and 'one' denote the binary 
digits 0 and 1. We may use a series of variables to denote 
a binary number. For example,

    X3 = one, X2 = zero, X1 = zero, X0 = one

represents 1001 (in base 2) which equals 9 (in base 10).
Write a Prolog predicate

    add(X3, X2, X1, X0, Y3, Y2, Y1, Y0, Z4, Z3, Z2, Z1, Z0)

that is true if

    (X3 X2 X1 X0) + (Y3 Y2 Y1 Y0) = (Z4 Z3 Z2 Z1 Z0)

where all variables are the atoms 'zero' or 'one', and groups 
of variables represent binary numbers as in the example above.

Because Prolog predicates work bidirectionally, your predicate 
will be able to perform subtraction as well as addition.

Note: In theory, you could solve the exercise by listing 256 
different facts. However, I will not accept any such answer. 
(A solution in fewer than 20 lines is possible.)

Important: Do not use any Prolog numbers or lists in this 
exercise. All variables must hold only atoms.

Example:

?- add(zero, one, zero, one,
|      zero, zero, one, one,
|      Z4, Z3, Z2, Z1, Z0).
Z4 = Z2, Z2 = Z1, Z1 = Z0, Z0 = zero,
Z3 = one .

Explanation: 5 + 3 = 8.

Example #2:

?- add(X3, X2, X1, X0,
|    zero, zero, one, one,
|    zero, one, zero, zero, zero).
X3 = X1, X1 = zero,
X2 = X0, X0 = one ;

Explanation: The solution to the equation X + 3 = 8 is X = 5.

Example #3:

?- add(X3, X2, X1, X0, Y3, Y2, Y1, Y0, one, one, one, one, one).
false.

Explanation: There are no two four-bit numbers X and Y such that X + Y = 31.
*/
bit(zero).
bit(one).

add_bit(CarryIn, CarryOut, Bit1, Bit2, Sum) :- 
    Bit1 = zero, Bit2 = zero, Sum = CarryIn, CarryOut = zero. 

add_bit(CarryIn, CarryOut, Bit1, Bit2, Sum) :- 
    Bit1 = one, Bit2 = one, Sum = CarryIn, CarryOut = one. 

add_bit(CarryIn, CarryOut, Bit1, Bit2, Sum) :- 
    Bit1 \= Bit2, Sum \= CarryIn, CarryOut = CarryIn. 

add(X3, X2, X1, X0, 
    Y3, Y2, Y1, Y0, 
    Z4, Z3, Z2, Z1, Z0) :-

    bit(X3), bit(X2), bit(X1), bit(X0),
    bit(Y3), bit(Y2), bit(Y1), bit(Y0),
    bit(Z4), bit(Z3), bit(Z2), bit(Z1), bit(Z0),
    bit(C2), bit(C1), bit(C0),

    add_bit(zero, C0, X0, Y0, Z0),
    add_bit(C0, C1, X1, Y1, Z1),
    add_bit(C1, C2, X2, Y2, Z2),
    add_bit(C2, Z4, X3, Y3, Z3).