:- module(settings, [is_morning_avoided/1, is_evening_avoided/1, is_lunch_necessary/0, sorted_by/1]).

:- dynamic is_morning_avoided/1.
:- dynamic is_evening_avoided/1.
:- dynamic is_lunch_necessary/0.
:- dynamic sorted_by/1.

/*SCHEDULE SETTINGS - TO TURN OFF A SETTING IN THIS CATEGORY, SIMPLY PUT '%' BEFORE IT*/

/*Avoids options starting before the defined hour*/
is_morning_avoided(10).

/*Avoids options starting after the defined hour*/
is_evening_avoided(20).

/*Ascertains that every day will have at least 30 minutes of free time between 10:00 and 14:00*/
% is_lunch_necessary.

/*SORTING SETTINGS*/

/*choose one of the following values:
    - compact: Sort the results by how much days will have to be spent in the university, preferring first schedules 
        with free days
    - transit: Sort the results by the total sum of time spent on transit between locations
*/
sorted_by(compact). 