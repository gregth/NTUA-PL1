bfs(NextOne, LengthOne, NextTwo, LengthTwo, NextThree, LengthThree, Cost):-
    iterate(NextOne, LengthOne, NextTwo, NextThree,
              NextOne1, LengthOne1, NextTwo1, LengthTwo1, NextThree1, LengthThree1, Finished),
    (  \+ Finished
    -> move_elements(NextTwo1, LengthTwo, NextOne1, NextTwo2, NextOne2),
       move_elements(NextThree1, LengthThree, NextTwo2, NextThree2, NextTwo3),
       LengthOne2 is LengthOne1 + LengthTwo,
       /*print('NextOne '), print(LengthOne2), nl, */
       LengthTwo2 is LengthTwo1 + LengthThree,
       /*print('NextTwo '), print(LengthTwo2), nl, */
       LengthThree2 is LengthThree1,
       /*print('NextThree '), print(LengthThree2), nl, */
       bfs(NextOne2, LengthOne2, NextTwo3, LengthTwo2, NextThree2, LengthThree2, NewCost),
       Cost is NewCost + 1, !
    ;  Cost is 0, !).

move_elements(Q, N, P, NewQ, NewP):-
    ( N = 0 -> NewQ = Q, NewP = P ;
      del_queue(E, Q, NQ),
      add_queue(E, P, NP),
      NN is N - 1,
      move_elements(NQ, NN, NP, NewQ, NewP)
    ).

iterate(NextOne, LengthOne,  NextTwo, NextThree,
        FinalOne, FinalLengthOne, FinalTwo, FinalLengthTwo, FinalThree, FinalLengthThree, Finished):-
    (  LengthOne = 0
    -> FinalOne = NextOne, FinalLengthOne = 0,
       FinalTwo = NextTwo, FinalLengthTwo = 0,
       FinalThree = NextThree, FinalLengthThree = 0,
       Finished = false,
       ! /*print('none left')*/
    ;  /*print(LengthOne), print(' left '),*/ del_queue((X, Y, M), NextOne, NextOne1), /*print((X,Y,M)),*/
       (  is_end(X, Y)
       -> (assert(arrived(X, Y, M)), Finished = true, FinalOne = NextOne, FinalLengthOne = 0,
       FinalTwo = NextTwo, FinalLengthTwo = 0,
       FinalThree = NextThree, FinalLengthThree = 0)
       ;  (  is_dot(X, Y)
          -> retract(is_dot(X, Y)),
             assert(arrived(X, Y, M)),
             move_from(X, Y, NextOne1, NextTwo, NextThree, NextOne2, N, NextTwo1, K, NextThree1, L)
          ;  NextOne2 = NextOne1, N = 0, NextTwo1 = NextTwo, K = 0, NextThree1 = NextThree, L = 0
          ),
          NewLengthOne is LengthOne - 1,
          iterate(NextOne2, NewLengthOne,  NextTwo1, NextThree1,
                  FinalOne, NFinalLengthOne, FinalTwo, NFinalLengthTwo, FinalThree, NFinalLengthThree, Finished),
          FinalLengthOne is NFinalLengthOne + N,
          FinalLengthTwo is NFinalLengthTwo + K,
          FinalLengthThree is NFinalLengthThree + L
       )
    ).

move_from(X, Y, NextOne, NextTwo, NextThree, NewOne, N, NewTwo, K, NewThree, L):-
    /*print('I am at'), print(X), print(' '), print(Y), print('and I can go'), nl,*/
    (  NewX is X - 1, (is_dot(NewX, Y) ; is_end(NewX, Y))
    -> add_queue((NewX, Y, 'U'), NextThree, NewThree), L = 1/*, print(NewX), print(Y), nl*/
    ;  NewThree = NextThree, L = 0
    ),
    (  NewX1 is X + 1, (is_dot(NewX1, Y) ; is_end(NewX1, Y))
    -> add_queue((NewX1, Y, 'D'), NextOne, NextOne1), NewN = 1/*, print('DOWN'), nl*/
    ;  NextOne1 = NextOne, NewN = 0/*, print(foo)*/
    ),
    (  NewY is Y - 1, (is_dot(X, NewY) ; is_end(X, NewY))
    -> add_queue((X, NewY, 'L'), NextTwo, NewTwo), K = 1/*, print('LEFT'), nl*/
    ;  NewTwo = NextTwo, K = 0
    ),
    (  NewY1 is Y + 1, (is_dot(X, NewY1) ; is_end(X, NewY1))/*, print('RIGHT'), nl*/
    -> add_queue((X, NewY1, 'R'), NextOne1, NewOne), N is NewN + 1
    ;  NewOne = NextOne1, N = NewN
    ).

prev(X, Y, 'U', NewX, NewY):-
    NewX is X + 1,
    NewY is Y.
prev(X, Y, 'D', NewX, NewY):-
    NewX is X - 1,
    NewY is Y.
prev(X, Y, 'L', NewX, NewY):-
    NewX is X,
    NewY is Y + 1.
prev(X, Y, 'R', NewX, NewY):-
    NewX is X,
    NewY is Y - 1.

calculate_path(Path, X, Y):-
    is_start(X, Y) -> Path = ''
    ; arrived(X, Y, M), prev(X, Y, M, NewX, NewY), !,
      calculate_path(NewPath, NewX, NewY),
      concat(NewPath, M, Path).

/*
*Queue implementation taken from
*F.Kluzniak & S.Szpakowicz, Prolog for Programmers
*Differnce lists are used
*A Queue Q is expressed as X-Y where concat(Q,Y,X) = true.
*/

create_queue(L-L).
add_queue(E, L-[E|R], L-R). /* E is an element, second and thrid arguments are queues,
                               third argument is the resulting queue when E is added to the second argument*/

del_queue(E, L-Last, NewL-Last) :-
    \+ (L == Last),
    L = [E|NewL].

empty_queue(L-M) :-
    L = M.

assert_map(['.'|Tail], N, M):-
    assert(is_dot(N, M)),
    NewM is M + 1,
    !,
    assert_map(Tail, N, NewM).
assert_map(['X'|Tail], N, M):-
    NewM is M + 1,
    !,
    assert_map(Tail, N, NewM).
assert_map([],_,_):-
    !.
assert_map(['S'|Tail], N, M):-
    assert(is_start(N, M)),
    assert(is_dot(N, M)),
    NewM is M + 1,
    !,
    assert_map(Tail, N, NewM).
assert_map(['E'|Tail], N, M):-
    assert(is_end(N, M)),
    NewM is M + 1,
    !,
    assert_map(Tail, N, NewM).

read_input(File):-
    open(File, read, Stream),
    scan_stream(Stream, 0).

scan_stream(Stream, N):-
    read_line_to_codes(Stream, Line),
    ( Line = end_of_file -> !
    ; atom_codes(A, Line),
      atom_chars(A, CharList),
      assert_map(CharList, N, 0),
      NewN is N + 1,
      scan_stream(Stream, NewN)
    ).

moredeli(File, Cost, Path):-
    read_input(File),
    create_queue(OneMin),
    is_start(X, Y),
    add_queue((X, Y, 'S'), OneMin, NewOne),
    create_queue(TwoMins),
    create_queue(ThreeMins),
    bfs(NewOne, 1, TwoMins, 0, ThreeMins, 0, Cost),
    is_end(A,B),
    calculate_path(Path, A, B).


















