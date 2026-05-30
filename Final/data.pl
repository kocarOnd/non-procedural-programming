:- module(data, [course/6, building/1, distance/3, room/2]).

/*Course Settings*/
/*course(Name, GroupID, Day, StartHour:StartMin, EndHour:EndMin, Room)
Name               : Name of the course
GroupID            : Option number so that we can distinguish between 
different options for the same course
Day                : Day of the week in lower case
StartHour, StartMin: When the course begins
EndHour, EndMin    : When the course ends
Room               : In what room it takes place*/

course(mathematical_analysis, 1, monday, 9:00, 10:30, k1).
course(mathematical_analysis_tutorial, 1, monday, 10:40, 12:10, k3).
course(linear_algebra, 1, tuesday, 10:40, 12:10, s5).
course(linear_algebra_tutorial, 1, tuesday, 12:20, 13:50, s9).
course(ads, 1, wednesday, 14:00, 15:30, s3).
course(ads_tutorial, 1, wednesday, 15:40, 17:10, s3).
course(programming, 1, thursday, 9:00, 10:30, s1).
course(programming_tutorial, 1, thursday, 10:40, 12:10, su1).
course(deep_learning, 1, friday, 9:00, 10:30, s1).
course(deep_learning_tutorial, 1, friday, 10:40, 12:10, su2).
course(computer_architecture, 1, tuesday, 14:00, 15:30, s4).
course(discrete_mathematics, 1, wednesday, 9:00, 10:30, s1).

/*Buildings Settings*/
/*building(x), distance(x, y, time-in-minutes), room(building, x)*/

building(troja).
building(malastrana).
building(karlov).
building(karlin).

distance(troja, malastrana, 30).
distance(troja, karlin, 20).
distance(troja, karlov, 40).
distance(malastrana, karlov, 30).
distance(malastrana, karlin, 20).
distance(karlov, karlin, 30).

room(malastrana, s1).
room(malastrana, s3).
room(malastrana, s4).
room(malastrana, s5).
room(malastrana, s6).
room(malastrana, s7).
room(malastrana, s8).
room(malastrana, s9).
room(malastrana, s10).
room(malastrana, s11).
room(malastrana, sw1).
room(malastrana, sw2).
room(malastrana, su1).
room(malastrana, su2).

room(troja, n1).
room(troja, n2).
room(troja, n3).
room(troja, n4).
room(troja, n5).
room(troja, n6).
room(troja, n7).
room(troja, n8).
room(troja, n9).
room(troja, n10).
room(troja, n11).
room(troja, t1).
room(troja, t2).
room(troja, t5).
room(troja, t6).
room(troja, t7).
room(troja, t8).
room(troja, t9).
room(troja, t10).

room(karlov, f1).
room(karlov, f2).
room(karlov, kfk).
room(karlov, m1).
room(karlov, m2).
room(karlov, m3).
room(karlov, m5).
room(karlov, m6).

room(karlin, k1).
room(karlin, k2).
room(karlin, k3).
room(karlin, k4).
room(karlin, k5).
room(karlin, k6).
room(karlin, k7).
room(karlin, k8).
room(karlin, k9).
room(karlin, k10).
room(karlin, k11).
room(karlin, k12).