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


stations_from_list(StationList) :-
    station_fact(StationList, 0).

station_fact([], _).

station_fact([StationAltitude|Tail], Index) :-
    assert(station(Index, StationAltitude)),
    NextIndex is Index + 1,
    station_fact(Tail, NextIndex).

/* A predicate that holds when alitude of end staion is
 * <= altitude of start station, and the distance between them is D.
 */
possible_ski(D, StartStation, EndStation) :-
    station(StartStation, StartAlt),
    station(EndStation, EndAlt),
    StartAlt >= EndAlt,
    StartStation >= EndStation,
    D is StartStation - EndStation,
    !.

max_ski(0, 0) := !.
max_ski(CurrDist, Dmax) :-
    ( possible_ski(CurrDist, StartStation, EndStation)
    ->  Dmax = CurrDist,
        !
    ;   NextCurrDist is CurrDist - 1,
        max_ski(NextCurrDist, Dmax)
    ).

skitrip(File, Result) :-
    read_input(File, N, L),
    stations_from_list(L),
    max_ski(N,Result).
