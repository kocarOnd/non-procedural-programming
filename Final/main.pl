:- use_module(data).
:- use_module(library(clpfd)).
:- use_module(view).

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

/*Make distances bidirectional*/
travel_time(Building, Building, 0). 
travel_time(A, B, Time) :- distance(A, B, Time). 
travel_time(A, B, Time) :- distance(B, A, Time). 

/*TURNING DATA TO CSP*/

/*Build table of travel distances*/
travel_tuples(TravelTable) :-
    findall(
        [ID1, ID2, Time],
        (
            travel_time(BldgA, BldgB, Time),
            
            building_id(BldgA, ID1),
            building_id(BldgB, ID2)
        ),
        TravelTable
    ).

/*Find all possibilities for some course and return it as a list of tuples (table)*/
course_tuples(Name, Tuples) :-
    findall(
        [ID, Start, End, BldgInt], 
        (
            course(Name, ID, Day, StartH:StartM, EndH:EndM, Room),
            
            room(BldgName, Room),
            building_id(BldgName, BldgInt),
            
            day_value(Day, DayInt),
            Start is ((DayInt * 24) + StartH) * 60 + StartM,
            End is ((DayInt * 24) + EndH) * 60 + EndM
        ), 
        Tuples
    ).

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

/*SORTING LOGIC*/

/*attach_time(InputValue, Key-InputValue) - to use the keysort*/
attach_time(Name-GroupID, StartTotal-(Name-GroupID)) :-
    course(Name, GroupID, Day, StartH:StartM, _, _),
            
    day_value(Day, DayInt),
    StartTotal is ((DayInt * 24) + StartH) * 60 + StartM.

sort_schedule(Schedule, SortedSchedule) :-
    maplist(attach_time, Schedule, KeyedSchedule),
    
    keysort(KeyedSchedule, SortedKeyedSchedule),
    
    pairs_values(SortedKeyedSchedule, SortedSchedule).
     
/*MAIN SOLVER LOGIC*/

solve(Schedule) :-
    all_courses(CourseNames),
    build_variables(CourseNames, Schedule),
    
    pairs_values(Schedule, VarsOnly),
    
    valid_schedule(Schedule),
    
    labeling([], VarsOnly),

    sort_schedule(Schedule, SortedSchedule),

    print_schedule(SortedSchedule).

valid_schedule([]).
valid_schedule([Pair|Rest]) :-
    valid_pair(Pair, Rest),
    valid_schedule(Rest).

valid_pair(_, []).
valid_pair(Name1-Var1, [Name2-Var2 | Rest]) :-
    course_tuples(Name1, Tuples1),
    course_tuples(Name2, Tuples2),

    [Start1, End1, Bldg1] ins 0..10000, 
    [Start2, End2, Bldg2] ins 0..10000,
    
    tuples_in([[Var1, Start1, End1, Bldg1]], Tuples1),
    tuples_in([[Var2, Start2, End2, Bldg2]], Tuples2),
    
    travel_tuples(TravelTable),
    tuples_in([[Bldg1, Bldg2, TravelTime]], TravelTable),
    
    (End1 + TravelTime #=< Start2) #\/ (End2 + TravelTime #=< Start1),
    
    valid_pair(Name1-Var1, Rest).