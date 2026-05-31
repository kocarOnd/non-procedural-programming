:- module(view, [print_schedule/1]).
:- use_module(data).

/*Add 0 when printing time with less than 10 minutes*/
print_time(Hour, Minute) :-
    Minute < 10, !, 
    format('~w:0~w', [Hour, Minute]).
print_time(Hour, Minute) :-
    format('~w:~w', [Hour, Minute]).

print_schedule(Schedule) :-
    format('~n===================================================================~n'),
    format('                      GENERATED TIMETABLE                          ~n'),
    format('===================================================================~n'),
    format('~w~t~25| ~w~t~35| ~w~t~45| ~w~t~60| ~w~n', 
           ['Course', 'Group', 'Day', 'Time', 'Room']),
    format('-------------------------------------------------------------------~n'),
    print_courses(Schedule),
    format('===================================================================~n').

print_courses([]).

print_courses([Name-GroupID | Rest]) :-
    course(Name, GroupID, Day, StartH:StartM, EndH:EndM, Room),
    
    format('~w~t~25| ~w~t~35| ~w~t~45| ', [Name, GroupID, Day]),
    
    print_time(StartH, StartM),
    format(' - '),
    print_time(EndH, EndM),
    
    format('~t~60| ~w~n', [Room]),
    
    print_courses(Rest).