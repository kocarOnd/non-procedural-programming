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