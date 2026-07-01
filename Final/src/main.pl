:- use_module(data).
:- use_module(library(clpfd)).
:- use_module(view).
:- use_module(settings).

/*TURNING ATOMS TO INTEGERS*/

day_value(monday, 0).
day_value(tuesday, 1).
day_value(wednesday, 2).
day_value(thursday, 3).
day_value(friday, 4).

/*Turning building atoms from data to integers for clpfd*/
building_id(BuildingName, ID) :-
    setof(B, building(B), AllBuildings),
    nth1(ID, AllBuildings, BuildingName). 

/*HELPER FUNCTIONS*/

/*Make distances bidirectional*/
travel_time(Building, Building, 0). 
travel_time(A, B, Time) :- distance(A, B, Time). 
travel_time(A, B, Time) :- distance(B, A, Time). 

/*Returns true if predicate succeeds on any couple from given lists*/
any(Pred, [X|_], [Y|_]) :-
    call(Pred, X, Y),
    !. 
any(Pred, [_|Xs], [_|Ys]) :-
    any(Pred, Xs, Ys).

/*Creates a predicate holding all course info from Name-GroupID couple*/
find_info(Name-GroupID, class(Name, GroupID, Day, Stime, Etime, Building)) :-
    course(Name, GroupID, Day, Shour:Smin, Ehour:Emin, Room),
    Stime is Shour * 60 + Smin,
    Etime is Ehour * 60 + Emin,
    room(Building, Room).

/*Sorts a List using keysort with the given predicate generating the keys*/
keysort_list_by(Predicate, List, SortedList) :-
    maplist(Predicate, List, KeyedList), 

    keysort(KeyedList, SortedKeyedList),

    pairs_values(SortedKeyedList, SortedList).

extract_day(class(_, _, Day, _, _, _), Day).

/*Extracts all unique days from a schedule expanded by find_info/2*/
get_unique_days(ExpandedSchedule, UniqueDays) :-
    maplist(extract_day, ExpandedSchedule, AllDays),
    sort(AllDays, UniqueDays).

/*Returns the desired length of a chunk to be printed*/
get_max_schedules_limit(N) :-
    max_results(N), !.
get_max_schedules_limit(N) :-
    N = 5.

/*ADDITIONAL CONDITIONS LOGIC*/

/*Evaluates the morning condition based on settings.pl values*/
morning_condition(SHour) :-
    is_morning_avoided(Limit), !,
    SHour >= Limit.
morning_condition(_) :- 
    true.

/*Evaluates the evening condition based on settings.pl values*/
evening_condition(EHour, Eminute) :-
    is_evening_avoided(Limit), !,
    (
        EHour < Limit;
        (EHour =:= Limit, Eminute =:= 0)
    ).
evening_condition(_, _) :-
    true.

/*Evaluates the lunch condition based on settings.pl values*/
check_lunch_breaks(Schedule) :-
    is_lunch_necessary, !,
    maplist(find_info, Schedule, ExpandedSchedule),

    get_unique_days(ExpandedSchedule, UniqueDays),

    check_valid_days(UniqueDays, ExpandedSchedule).
check_lunch_breaks(_) :-
    true.

/*Checks that for every day in Days, there is at least 30 minutes of break between 10:00 and 14:00*/
check_valid_days([], _).
check_valid_days([Day | Days], ExpandedSchedule) :-
    findall(Class, 
        (
            member(Class, ExpandedSchedule), 
            Class = class(_, _, Day, _, _, _)
        ), 
        DailyClasses),
    sort(4, @=<, DailyClasses, SortedClasses),

    once(
       (
            ( /*Case 1: Uni starts after 10:30*/
                SortedClasses = [FirstClass | _],
                FirstClass = class(_, _, _, Stime, _, _),
                Stime >= 630
            );
            ( /*Case 2: Uni finishes before 13:30*/
                last(SortedClasses, LastClass),
                LastClass = class(_, _, _, _, Etime, _),
                Etime =< 810
            );
            ( /*Case 3: There is a 30 minute gap between 2 classes*/
                SortedClasses = [_ | Rest],
                any(check_pair_gap, SortedClasses, Rest)
            ) 
        )
    ),
    check_valid_days(Days, ExpandedSchedule).

/*Ascertains that the gap between Class1 and Class2 is 30 minutes long within 10 to 14 window*/
check_pair_gap(Class1, Class2) :- 
    Class1 = class(_, _, _, _, Etime, Bldg1),
    Class2 = class(_, _, _, Stime, _, Bldg2),

    travel_time(Bldg1, Bldg2, TravelTime),

    Etime < 810, % First class must end before 13:30 
    Stime >= 630, % Second class must start after 10:30

    RestTime is Stime - Etime - TravelTime,
    RestTime >= 30.

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

            morning_condition(StartH),
            evening_condition(EndH, EndM),
            
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
    findall(GroupID, course(Name, GroupID, _, _, _, _), Groups),
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

/*Evaluates a schedule and attaches the score to it*/
score_schedule(Schedule, ScoredPair) :-
    sorted_by(compact), !,

    maplist(find_info, Schedule, ExpandedSchedule),

    get_unique_days(ExpandedSchedule, UniqueDays),

    maplist(evaluate_day, UniqueDays, DayValues),

    sum_list(DayValues, Sum),

    ScoredPair = Sum-Schedule.
score_schedule(Schedule, ScoredPair) :-
    sorted_by(transit), !,

    maplist(find_info, Schedule, ExpandedSchedule),
    get_unique_days(ExpandedSchedule, UniqueDays),
    
    maplist(daily_transit(ExpandedSchedule), UniqueDays, DailyTransits),
    
    sum_list(DailyTransits, Sum),
    ScoredPair = Sum-Schedule.
score_schedule(Schedule, ScoredPair) :- /*Default behaviour is just compact scoring for now*/
    maplist(find_info, Schedule, ExpandedSchedule),

    get_unique_days(ExpandedSchedule, UniqueDays),

    maplist(evaluate_day, UniqueDays, DayValues),

    sum_list(DayValues, Sum),

    ScoredPair = Sum-Schedule.

/*Turns day into a value of how unsought it is (Mo-Fr = 25-16-9-16-25)*/
evaluate_day(Day, DayEvaluation) :-
    day_value(Day, DayInt),

    DayEvaluation is (abs(DayInt - 2) + 3) ^ 2.

/*Calculates the amount of transit time on one specific day*/
daily_transit(ExpandedSchedule, Day, TotalDailyTime) :-
    findall(Class, 
        (
            member(Class, ExpandedSchedule), 
            Class = class(_, _, Day, _, _, _)
        ), 
        DailyClasses),
        
    sort(4, @=<, DailyClasses, SortedClasses),
    
    sum_transitions(SortedClasses, TotalDailyTime).

/*Sums the transition time in a list of consequent classes*/
sum_transitions([], 0).
sum_transitions([_], 0).
sum_transitions([C1, C2 | Rest], TotalTime) :-
    C1 = class(_, _, _, _, _, Bldg1),
    C2 = class(_, _, _, _, _, Bldg2),
    
    travel_time(Bldg1, Bldg2, Time),
    
    sum_transitions([C2 | Rest], RestTime),
    
    TotalTime is Time + RestTime.
     
/*MAIN SOLVER LOGIC*/

solve(Schedule) :-
    all_courses(CourseNames),
    build_variables(CourseNames, Schedule),
    pairs_values(Schedule, VarsOnly),
    valid_schedule(Schedule),
    
    findall(
        Schedule, 
        (
            labeling([], VarsOnly),
            check_lunch_breaks(Schedule)
        ), 
        AllValidSchedules
    ),

    maplist(keysort_list_by(attach_time), AllValidSchedules, OrganisedSchedules),
    keysort_list_by(score_schedule, OrganisedSchedules, SortedSchedules),

    get_max_schedules_limit(N),
    print_in_chunks(SortedSchedules, N).

/*Ascertain that the schedule comply with the constraints*/
valid_schedule([]).
valid_schedule([Pair|Rest]) :-
    valid_pair(Pair, Rest),
    valid_schedule(Rest).

/*Ascertains that a pair of classes comply with the constraints*/
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

run :- 
    solve(_).