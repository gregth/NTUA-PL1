/* File parser code taken from http://courses.softlab.ntua.gr/pl1/2017a/Exercises/read_hopping_SWI.pl
 * A predicate that reads the input from File and returns it in
 * the next arguments NumStations and StationList.
 *
 * UsageExample: ?- read_input('h1.txt', N, K, B, Steps, Broken).
 */

read_input(File, NumStations, StationsList) :-
    open(File, read, Stream),
    read_line(Stream, NumStations),
    read_line(Stream, StationsList).

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

/* A predicate that sets the facts about the stations,
 * taking as argumen  a list containing their altitudes.
 */


stations_from_list(StationList,N, StartStationList, EndStationList) :-
    [Head|_] = StationList,
    Minimum is Head+1,
    end_station_fact(StationList, 0, Minimum, EndStationList),
    reverse(StationList, RevStationList),
    [RevHead|_] = RevStationList,
    Maximum is RevHead-1,
    NewN is N - 1,
    start_station_fact(RevStationList, NewN, Maximum, StartStationList).

start_station_fact([], _, _, []).

start_station_fact([StationAltitude|Tail], Index, Maximum, StartStationsList) :-
    NextIndex is Index - 1,
    ((StationAltitude > Maximum) ->
    (NextMaximum is StationAltitude,
    start_station_fact(Tail, NextIndex, NextMaximum, NewStartStationsList),
    StartStationsList = [(Index, StationAltitude)| NewStartStationsList]
    )
    ; start_station_fact(Tail, NextIndex, Maximum, StartStationsList)).

end_station_fact([], _, _, []).

end_station_fact([StationAltitude|Tail], Index, Minimum, EndStationsList) :-
    NextIndex is Index + 1,
    ((StationAltitude < Minimum) ->
    (NextMinimum is StationAltitude,
    end_station_fact(Tail, NextIndex, NextMinimum, NewEndStationsList),
    EndStationsList = [(Index, StationAltitude)| NewEndStationsList]
    )
    ; end_station_fact(Tail, NextIndex, Minimum, EndStationsList)).


merge([],L2,Merged):-
    Merged = L2, !.
merge(L1,[],Merged):-
    Merged = L1, !.
merge(L1,L2,Merged):-
    [(N,X)|T1] = L1,
    [(M,Y)|T2] = L2,
    (   (X < Y ; X = Y , N < M) -> merge(T1, L2, NewMerged), Merged = [(N,X)|NewMerged]
    ;   merge(L1, T2, NewMerged), Merged = [(M,Y)|NewMerged]
    ).

max_ski(BestStart, BestEnd, _, [], Result):-
    Result is BestStart - BestEnd, !.
max_ski(BestStart, BestEnd, BestIndex, List, Result):-
    [(K,_)|Tail] = List,
    CurrentDist is K - BestIndex,
    BestDist = BestStart - BestEnd,
    (   CurrentDist > BestDist -> max_ski(K, BestIndex, BestIndex, Tail, Result)
    ;   (   BestIndex > K -> max_ski(BestStart, BestEnd, K, Tail, Result)
        ;   max_ski(BestStart, BestEnd, BestIndex, Tail, Result)
        )
    ).

skitrip(File, Result) :-
    read_input(File, N, L),
    stations_from_list(L,N,SL,EL),
    reverse(EL,REL),
    merge(SL,REL,Merged),
    [(K,_)|Tail] = Merged,
    max_ski(K,K,K,Tail,Result).

















