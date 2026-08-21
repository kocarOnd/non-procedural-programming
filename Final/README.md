# Courses Scheduler Using CLP(FD) Library

## Overview

Prolog-based tool that helps students generate possible schedules with no overlapping classes for their next semester using Constraint Logic Programming. 

## Requirements

- [SWI-Prolog](https://www.swi-prolog.org/) (version 8.0+)

Note: No additional libraries need to be installed; the CLP(FD) library ships with SWI-Prolog.

## Project Structure

```
.
├── src/              # Repository with the source code
│   ├── data.pl       # Courses, rooms, buildings, and travel times
│   ├── main.pl       # Solver — run this to generate a schedule
│   ├── settings.pl   # User-controlled settings of the solver
│   ├── validator.pl  # Data integrity checker
│   └── view.pl       # Logic for schedule printing
└── developer.md      # Additional documentation for developers
```

## Quick Start

### 1. Launch SWI-Prolog and load the solver

```prolog
swipl src/main.pl
```
Note: You might use `?- ['src/main.pl'].` in case you have already started your prolog session

### 2. Run the solver

```prolog
?- run.
```

Note: The solver will search for valid schedules and print them in chunks directly to the console. You can set the size of the chunk in `settings.pl`. If the amount of schedules is larger than the size of the chunk, press `;` to find the next one, or `.` to stop.

### 3. (Optional) Validate your data before solving

```prolog
swipl validator.pl
?- validate_data.
```

Note: This checks for common data issues — unknown buildings, invalid times, correct formulation, etc. Especially useful after editing `data.pl`. \
Note 2: You can use `?- ['src/validator.pl'].` in case you have already started your Prolog session.

## Understanding the Output

A successful run prints a table like the one below:

```
===================================================================
                      GENERATED TIMETABLE                          
===================================================================
Course                    Group     Day          Time          Room
-------------------------------------------------------------------
calculus_1                1         monday       9:00 - 10:30  k1
calculus_1_tutorial       1         monday       10:40 - 12:10 k3
intro_to_programming      1         monday       14:00 - 15:30 s1
...
===================================================================
```

Results are sorted chronologically by day and start time. The **Group** column tells you which option was picked for each course — useful when cross-referencing with an official timetable.

If no valid schedule exists the query simply fails and returns `false.`.

## Customising Your Data

All schedule data lives in `data.pl`. This can be edited freely to match own courses and campus.

### Adding or removing courses

Each course is defined with:

```prolog
course(Name, GroupID, Day, StartHour:StartMin, EndHour:EndMin, Room).
```

| Field | Description |
|---|---|
| `Name` | Course identifier (an atom, e.g. `linear_algebra`) |
| `GroupID` | Option number for this course (start at `1`, increment per option) |
| `Day` | Day of the week in lowercase (`monday` … `friday`) |
| `StartHour:StartMin` | Start time in 24-hour format |
| `EndHour:EndMin` | End time in 24-hour format |
| `Room` | Room atom as defined under `room/2` |

**Example** — a course with two options:

```prolog
course(linear_algebra, 1, tuesday,  9:00, 10:30, k5).
course(linear_algebra, 2, thursday, 14:00, 15:30, k5).
```

Group IDs must be *consecutive integers starting from 1*.

### Adding buildings

```prolog
building(name).
```

### Adding rooms

```prolog
room(building_name, room_id).
```

Every room must belong to an already declared building.

### Adding travel times

```prolog
distance(building_a, building_b, TimeInMinutes).
```

Distances are **bidirectional** — you only need to declare each pair once. Travel time between a building and itself is always zero and need not be declared. Every pair of buildings that *shares at least one course between them* should have a distance entry; missing entries will cause the solver to fail.

## Customizing the Behaviour

The solver mechanics can be affected by the information found in `settings.pl`. Every setting can be turned off by commenting it out (putting the character `%` before it). There are several possible settings found in that file, whose description follows:

1. Schedule Settings
    -
    These settings are used to further limit the amount of valid schedules.

    - `is_morning_avoided(N)`: If active, this setting throws away all classes starting before the `N`-th hour in the morning.
    - `is_evening_avoided(N)`: If active, this setting throws away all classes finishing after the `N`-th hour in the evening.
    - `is_lunch_necessary`: If active, this setting ascertains that there is always at least 30 minutes of free time between 10 and 14.
2. Print Settings
    -
    These settings are used to style the response to accomodate your needs.

    - `sorted_by(Choice)`: Decides how the results are sorted. There are 2 possible values for `Choice` — `compact` and `transit`. When `compact` is chosen, the scheduler prefers schedules with the lowest amount of days spent at the university first. When `transit` is chosen, the results are sorted ascendingly by the total amount of transit time during the week. When this setting is off, `compact` sorting will be chosen.
    - `max_results(N)`: Decides the size of a chunk. The results are printed in groups of `N` size. When this setting is off, `N` is assumed to be 5.

## How It Works 

For every course in `data.pl`, the solver picks exactly one of its available time slots (groups). It then checks every pair of selected slots against several rules:

1. **No time overlap** — two classes cannot be attended at the same time.
2. **Enough travel time** — if two back-to-back classes are in different buildings, the gap between them must be at least as long as the travel time between those buildings.
3. **Additional rules** — specified in `settings.pl`, the solver apply additional constraint rules and sorts the results. More information in the section **Customizing the Behaviour**.

The solver explores all combinations and returns only those that satisfy all rules for every pair of courses.
