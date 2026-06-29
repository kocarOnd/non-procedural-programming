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

course(linear_algebra, 1, monday, 8:00, 9:30, k1).
course(linear_algebra, 2, monday, 10:40, 12:10, k1).

course(database_systems, 1, wednesday, 18:30, 20:00, s1).
course(database_systems, 2, wednesday, 19:15, 20:45, s1).

course(computer_graphics, 1, friday, 8:00, 9:30, s3).
course(computer_graphics, 2, friday, 14:10, 15:40, s3).

course(software_eng, 1, tuesday, 10:40, 12:10, s5).
course(software_eng, 2, thursday, 10:40, 12:10, s5).

course(ai_basics, 1, tuesday, 13:10, 14:40, s5).
course(ai_basics, 2, thursday, 12:20, 13:50, s5).

course(quantum_computing, 1, wednesday, 10:00, 11:30, t1).
course(quantum_computing, 2, wednesday, 12:30, 14:00, f1).
course(quantum_computing, 3, wednesday, 14:30, 16:00, f1).

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