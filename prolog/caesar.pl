/*Task:In a simple Caesar cipher, each letter is rotated forward in the alphabet by some number of 
places K. For example, if we encrypt the word 'YES' with K = 3 then we obtain 'BHV'. If the key K 
is known, the cipher can be decrypted by rotating each letter by the inverse value -K.

In this assignment, we will consider a slightly more complicated cipher in which there are two keys 
K1 and K2. To encrypt each word, all letters at odd positions in the word are rotated by K1, and 
letters at even positions are rotated by K2. For example, if K1 = 1 and K2 = 6 and we encrypt the 
word "DONUT", we obtain "EUOAU", because

   D + 1 = E
   O + 6 = U
   N + 1 = O
   U + 6 = A
   T + 1 = U

Write a predicate decrypt(+C, +D, -M) that takes an encrypted text C and a list of words D, and 
produces the original text M. All words in the text have been encrypted with the same keys K1 and K2. 
Their values are not known, however it is guaranteed that every word in the decrypted text will be 
in the given list D. All words will contain only lowercase letters in the range 'a' .. 'z'.

If there is more than one possible answer, your predicate should succeed once for each possibility.
*/

decrypt(C, D, M) :- 
    split_string(C, " ", " ", EncryptedWords),
    decrypt_all(EncryptedWords, D, DecryptedWords, _, _),
    atomics_to_string(DecryptedWords, " ", M).


decrypt_all([], _, [], _, _).
decrypt_all([E | ETail], Dictionary, [D | DTail], K1, K2) :-
    member(D, Dictionary),
    decrypt_word(E, D, K1, K2),
    decrypt_all(ETail, Dictionary, DTail, K1, K2).

decrypt_word(E, D, K1, K2) :-
    string_codes(E, ECodes),
    string_codes(D, DCodes),
    decrypt_codes(ECodes, DCodes, K1, K2).

decrypt_codes([], [], _, _). 
decrypt_codes([E], [D], K, _) :-
    K is (E - D) mod 26.
decrypt_codes([E1, E2 | ETail], [D1, D2 | DTail], K1, K2) :-
    K1 is (E1 - D1) mod 26,
    K2 is (E2 - D2) mod 26,
    decrypt_codes(ETail, DTail, K1, K2).