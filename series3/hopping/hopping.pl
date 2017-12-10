/* File parser code taken from http://courses.softlab.ntua.gr/pl1/2017a/Exercises/read_hopping_SWI.pl
 * A predicate that reads the input from File and returns it in
 * the next arguments N, K, B, Moves, Broken.
 *
 * UsageExample: ?- read_input('h1.txt', N, K, B, Steps, Broken).
 */

read_input(File, N, K, B, Moves, Broken) :-
    open(File, read, Stream),
    read_line(Stream, [N, K, B]),
    read_line(Stream, Moves),
    read_line(Stream, Broken).

/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */

read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).

/* A predicate that replaces an old fact with a new one. 
 * Code taken from https://stackoverflow.com/questions/37871775/prolog-replace-fact-using-fact
 */

replace_existing_fact(OldFact, NewFact) :-
    (   call(OldFact)
    ->  retract(OldFact),
        assertz(NewFact)
    ;   true
    ).

/* Inititalizes way of access to each step = 0 
 * Especially for step no 1 the ways oa access are initialized to 1. 
 */
initialize_stair_ways(1, Broken) :-
	( member(1, Broken)
	-> assert(ways(1, -1))
	; assert(ways(1, 1))
	),
    !.

initialize_stair_ways(N,  Broken) :-
	( member(N, Broken)
	-> assert(ways(N, -1))
	; assert(ways(N, 0))
	),
    NextN is N - 1,
    initialize_stair_ways(NextN, Broken).

/* Calculates the steps that we can reach from StepId
 * with every possible move from list Moves.
 * Increments the ways of the steps we can reach properly.
 */

calculate_ways_from_step(_, _, []).
calculate_ways_from_step(StepId, N, [Move|Rest]) :-
    ways(StepId, CurrentWays),
    (\+ member(CurrentWays, [0, -1])
    -> NextStepId is StepId + Move,
        ( NextStepId =< N 
        -> ways(NextStepId, NextStepWays),
            (NextStepWays = -1
            -> NewNextStepWays = -1
            ; NewNextStepWays is NextStepWays + CurrentWays
            ),
            (NewNextStepWays >= 1000000009 
            -> NormalizedWays is mod(NewNextStepWays, 1000000009)
            ; NormalizedWays is NewNextStepWays
            ),
            replace_existing_fact(ways(NextStepId, _),ways(NextStepId,NormalizedWays))
        ;true
        )
    ;true
    ),
    calculate_ways_from_step(StepId, N, Rest).

/* Repeats calculation for all of the N steps */
calculate_for_all_steps(N, N, _) :-
    !.

calculate_for_all_steps(CurrentStep, N, Moves) :-
    once(calculate_ways_from_step(CurrentStep, N, Moves)),
    NextStep is CurrentStep + 1,
    calculate_for_all_steps(NextStep, N, Moves).

answer(N, Moves, Broken, Answer) :-
    initialize_stair_ways(N, Broken),
    calculate_for_all_steps(1,N, Moves),
    ways(N, Answer).

hopping(File, Answer) :-
    read_input(File, N, _, _, Moves, Broken),
    once(answer(N, Moves, Broken, Answer)).
