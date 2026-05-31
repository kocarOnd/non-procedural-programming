# Courses Scheduler Using CLP(FD) Library

## Overview

Prolog-based tool that helps students generate possible schedules with no overlapping classes for their next semester using Constraint Logic Programming. 

## Requirements

- [SWI-Prolog](https://www.swi-prolog.org/) (version 8.0 or later recommended)

Note: No additional libraries need to be installed; the CLP(FD) library ships with SWI-Prolog.

## Project Structure

```
.
├── src/              # Repository with the source code
│   ├── main.pl       # Solver — run this to generate a schedule
│   ├── data.pl       # Courses, rooms, buildings, and travel times
│   ├── validator.pl  # Data integrity checker
│   └── view.pl       # Logic for schedule printing
└── docs/             # Additional documentation for developers
```

## Quick Start

### 1. Launch SWI-Prolog and load the solver

```prolog
swipl src/main.pl
```
Note: You might use `?- ['src/main.pl'].` in case you have already started your prolog session

### 2. Run the solver

```prolog
?- solve(Schedule).
```

Note: The solver will search for a valid schedule and print it directly to the console. If multiple solutions exist, press `;` to find the next one, or `.` to stop.

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


## How It Works 

For every course in `data.pl`, the solver picks exactly one of its available time slots (groups). It then checks every pair of selected slots against two rules:

1. **No time overlap** — two classes cannot be attended at the same time.
2. **Enough travel time** — if two back-to-back classes are in different buildings, the gap between them must be at least as long as the travel time between those buildings.

The solver explores all combinations and returns only those that satisfy both rules for every pair of courses.
