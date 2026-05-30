:- use_module(data).
:- use_module(library(clpfd)).

/*TURNING ATOMS TO INTEGERS*/

day_value(monday, 0).
day_value(tuesday, 1).
day_value(wednesday, 2).
day_value(thursday, 3).
day_value(friday, 4).

/*I am turning building atoms from data to integers for clpfd
dynamically, because the amount of buildings may change for different data*/
building_id(BuildingName, ID) :-
    setof(B, building(B), AllBuildings),
    nth1(ID, AllBuildings, BuildingName). 

/*HELPER FUNCTIONS*/

/*Parse the time from human-friendly format to machine-friendly*/
course_minutes(Name, GroupId, StartTotal, EndTotal) :-
    course(Name, GroupId, Day, StartHour:StartMin, EndHour:EndMin, _),
    day_value(Day, DayInt),
    StartTotal is ((DayInt * 24) + StartHour) * 60 + StartMin,
    EndTotal is ((DayInt * 24) + EndHour) * 60 + EndMin.

/Make distances bidirectional*/
travel_time(Building, Building, 0). 
travel_time(A, B, Time) :- distance(A, B, Time). % A to B
travel_time(A, B, Time) :- distance(B, A, Time). % B to A

/*TURNING DATA TO CSP*/

/*Fetch a set of course names*/
all_courses(Courses) :-
    setof(Name, Group^Day^Start^End^Room^course(Name, Group, Day, Start, End, Room), Courses).

/*Give course its domain*/
course_domain(Name, Name-Var) :-
    findall(GroupId, course(Name, GroupId, _, _, _, _), Groups),
    max_list(Groups, MaxGroup),
    Var in 1..MaxGroup.

/*Build variable pairs*/
build_variables([], []).
build_variables([Name|Names], [VarPair|VarPairs]) :-
    course_domain(Name, VarPair),
    build_variables(Names, VarPairs).
     
/*MAIN SOLVER LOGIC*/

solve(Schedule) :-
    all_courses(CourseNames),
    build_variables(CourseNames, Schedule),
    
    pairs_values(Schedule, VarsOnly),
    
    valid_schedule(Schedule),
    
    labeling([], VarsOnly).

valid_schedule([]).
valid_schedule([Pair|Rest]) :-
    valid_pair(Pair, Rest),
    valid_schedule(Rest)

valid_pair(_, []).
valid_pair(Name1-Var1, [Name2-Var2|Rest]) :-
    /*some constraints for a pair of variables*/
    valid_pair(Name1-Var1, Rest).