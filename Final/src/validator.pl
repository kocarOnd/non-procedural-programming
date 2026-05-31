:- module(validator, [validate_data/0]).
:- use_module(data).

/*Write out the validation of data*/
validate_data :-
    format('~n=================================================~n'),
    format('           RUNNING DATA VALIDATION               ~n'),
    format('=================================================~n'),
    validate_buildings,
    validate_rooms,
    validate_distances,
    validate_courses,
    format('Validation completed. See errors above (if present)~n'),
    format('=================================================~n~n').

/*Check against duplicates among building*/
validate_buildings :-
    findall(B, building(B), Buildings),
    sort(Buildings, Sorted),
    length(Buildings, L1),
    length(Sorted, L2),
    ( L1 \= L2 -> format('[WARNING] There are duplicate building entries!~n') ; true ).

/*Check that every room belongs to a building atom*/
validate_rooms :-
    forall(room(Bldg, Room),
        ( building(Bldg) -> true 
        ; format('[ERROR] Room ~w belongs to unknown building: ~w~n', [Room, Bldg])
        )).

/*Check for distances between buildings and time being positive*/
validate_distances :-
    forall(distance(B1, B2, Time),
        ( 
            ( building(B1), building(B2) -> true 
            ; format('[ERROR] Distance between unknown buildings: ~w and ~w~n', [B1, B2]) ),
            ( integer(Time), Time >= 0 -> true 
            ; format('[ERROR] Invalid travel time (~w) between ~w and ~w~n', [Time, B1, B2]) )
        )).

valid_day(monday). valid_day(tuesday). valid_day(wednesday). 
valid_day(thursday). valid_day(friday). valid_day(saturday). valid_day(sunday).

valid_time(H, M) :- 
    integer(H), integer(M), 
    H >= 0, H < 24, 
    M >= 0, M < 60.

/*Check for valid day atom, valid times, rooms and whether start is before end*/
validate_courses :-
    forall(course(Name, Group, Day, StartH:StartM, EndH:EndM, Room),
        (
            ( valid_day(Day) -> true 
            ; format('[ERROR] ~w (Group ~w) has an invalid day: ~w~n', [Name, Group, Day]) ),
            
            ( valid_time(StartH, StartM) -> true 
            ; format('[ERROR] ~w (Group ~w) has invalid start time: ~w:~w~n', [Name, Group, StartH, StartM]) ),
            
            ( valid_time(EndH, EndM) -> true 
            ; format('[ERROR] ~w (Group ~w) has invalid end time: ~w:~w~n', [Name, Group, EndH, EndM]) ),
            
            ( valid_time(StartH, StartM), valid_time(EndH, EndM) ->
                StartTotal is (StartH * 60) + StartM,
                EndTotal is (EndH * 60) + EndM,
                ( StartTotal < EndTotal -> true 
                ; format('[ERROR] ~w (Group ~w) ends before or exactly when it starts!~n', [Name, Group]) )
            ; true ), 
            
            ( room(_, Room) -> true 
            ; format('[ERROR] ~w (Group ~w) takes place in unknown room: ~w~n', [Name, Group, Room]) )
        )).