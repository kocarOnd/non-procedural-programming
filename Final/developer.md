# Developer Documentation

This document aims to explain the architecture, responsibilities and logic used to resolve scheduling conflicts.

## Overview

This project aims to create a tool for students (me) for fast generation of possible schedules out of given course possibilities specified in `src/data.pl`. In case you wish to learn more about the possible and intended usage, I recommend you to read user documentation found in [README](README.md). It uses [constraint programming](https://en.wikipedia.org/wiki/Constraint_programming) to do so with the help of CLP(FD) library for Prolog. Since the usual algorithms for constraint problems have been implemented inside of this library already, this project focuses more on the **conversion** of the problem in the acceptable format rather than solving a constraint satisfaction problem (CSP) from the ground up. 

The following developer documentation is split into 4 parts that have been suggested to me by Gemini + final part about AI usage that I felt was a useful addition for evaluation. The parts therefore are: 
1. System Architecture & Control Flow
2. Module Breakdown
3. Core Algorithms & clpfd Mechanics
4. Expanding the Logic
5. AI Usage

## 1. System Architecture & Control Flow

The application is build around one command only — `solve/1` found in `src/main.pl`. And the logic is strictly divided into 4 different parts — **main.pl** that holds the application logic of converting information into a CSP and the `solve/1` predicate. **data.pl** that holds the actual data and facts used, stored in Prolog file, but kept the structure simple for the user to understand. **view.pl** that holds the printing logic so that the result of `solve/1` is shown to user in an ordered manner. And finally **validator.pl** that goes over the data and checks whether they have the correct structure for the conversion logic to be applied. This checking logic is not called by default and user has to call it manually with the predicate `validate_data/0`.

When `solve/1` is called, the process is split into following stages:
- **Data Ingestion & Normalization** — The solver queries data.pl to extract all unique course names using setof/3. Simultaneously, it normalizes human-readable atoms (like building names and days of the week) into pure integer IDs. This normalization is critical because the clpfd constraint engine only operates on integers.
- **Variable & Domain Generation** — For every unique course, the system dynamically generates an unbound Prolog variable. It queries the database to find the maximum number of parallel groups (sessions) for that course and sets the variable's clpfd domain to 1..MaxGroup.
  - Output at this stage is a list of key-value pairs associating a course name with an unassigned integer (e.g., [calculus_1 - Var1, physics_1 - Var2]).
- **Constraint Application** — The system passes the list of variables through a recursive loop (valid_schedule/1). For every unique pair of courses, it applies rules to prevent temporal and physical overlaps:
  - It builds tables of all valid start times, end times, and building IDs for a course using course_tuples/2.
  - It maps the unbound variables to these tables using tuples_in/2.
  - And finally enforces the core constraint — *Course A must end (plus travel time) before Course B begins, OR vice versa.*
- **Resolution (Labeling)** — With all constraints and truth tables loaded into memory, the system calls the clpfd's highly optimized labeling/2 predicate. The command explores the search place and gives us the result.
- **Post-Processing & Presentation** — The assigned schedule is processed for readability. The system calculates an absolute chronological key (StartTotal, representing minutes from the **beginning of the week**) for each class. It sorts the schedule using keysort/2 and passes the ordered list to view.pl for ASCII formatting.

## 2. Module Breakdown

As it has been previously stated, the project is split into modules. Every module has been given a file of its own as shown in the table below:

| Module Name | File Name | Description | Uses modules |
| --- | --- | --- | --- |
| (general module) | main.pl | Logic for conversion of data into CSP, holds predicates `solve/1` that is the main entry point that starts the solving pipeline, `valid_schedule/1` and `valid_pair/2` where the constraint logic is kept + helper predicates | data, view, clpfd (library)|
| data | data.pl | Holds user data used as the basis for the CSP, holds predicates `course/6`, `building/1`, `distance/3`, and `room/2` that hold the important facts from the real world | None |
| view | view.pl | Holds rules for formatting the result of `solve/1`, relying heavily on the `format/2` Prolog predicate | data |
| validator | validator.pl | Holds logic for checking the integrity of data found in data.pl, mostly using the `forall/2` predicate to iterate over all the values in knowledge base | data |
## 3. Core Algorithms & clpfd Mechanics

The major problem of this project was for sure translating the data into variables and their domains — especially to integers. For tackling this problem, I have decided to apply the following: 

- Time Normalization
  - Since time does not respect the typical 10 base of numbers, I had to translate the time from the form 9:15 for example to 555 since the beginning of the day. I have also faced the decision whether to create my constraints based on days (I would only check courses that occur on specific day) or whether I put all the courses on one timeline that begins on Monday 0:00 and resets on Friday. Eventually I have decided with the latter because it seemed easier to implement and process with a machine.
  - Therefore I use the following formula for counting the time: `TotalMinutes = (((DayIndex * 24) + Hour) * 60) + Minute`
- Table Constraints
  - Since the solver could not know which Group ID was going to be used, I have decided to use a bit different strategy. By using predicates such as `course_tuples/2`, I generate a table of possible values for a course and then I use the clpfd's `tuples_in/2` predicate to constraint the possible values only to the values appearing in the table.
- The Overlap & Travel Constraint 
  - The holy grail of my project is a simple line of code: 
  ```prolog
    (End1 + TravelTime #=< Start2) #\/ (End2 + TravelTime #=< Start1)
  ```
  This line uses the clpfd predicates `#=<` and `#\/` that create logical constraints for the time (note that `#\/` is a logical OR). It translates to "Either the course 1 end time + travel time does not exceed the start time of course 2 or the course 2 end time + travel time does not exceed the start time of course 1".
## 4. Expanding the Logic

The application is but a skeleton for additional logic. If you wish to add constraints or data, see the guidelines below:

### 4.1 Adding New Facts & Entities

For adding new concepts, just define new facts within `data.pl` (e.g., `teacher/2`). Please note that if the constraint solver needs to evaluate this entity, you will have to wite a predicate that **transfers the data into integers** (you may check `building_id/2` for reference).

### 4.2 Modifying Existing Data Structures

When altering existing data structure (such as adding *Capacity* to `course` definition), be sure to update the entire pipeline:

- Update every fact in `data.pl`.
- Update the setof query inside all_courses/1 in solver.pl to ignore the new variable (e.g., Capacity^).
- Update the tuple generation inside course_tuples/2 to extract or bypass the new data.
- Update the formatting logic in `view.pl` and the linting rules in `validator.pl`.

### 4.3 Adding New Constraints

All rules that define what makes a schedule "valid" belong in the `valid_schedule/1` and `valid_pair/2` loops within `solver.pl`.

- **Constraints between two courses** — Add these directly inside `valid_pair/2`. For example, if you want to make sure that two specific subjects are never scheduled on the same day, you would extract the `DayInt` from the tuples and add a `#\=` (not equal) constraint. See [arithmetic constraints](https://www.swi-prolog.org/pldoc/man?section=clpfd-arith-constraints), [logic constraints](https://www.swi-prolog.org/pldoc/man?section=clpfd-reification-predicates) and other clpfd predicates.
- **Global constraints** — Add these to `solve/1` immediately after the variable domain generation but before `labeling/2`. For example, using `sum/3` to enforce a maximum total number of hours per week.

## 5. AI Usage

I have used Gemini AI when creating this project in the following cases:

- **Consulting project structure** — Before programming anything, I have consulted what files and structure might be useful for this project. When programming inside the files itself, I have done the same to ensure a proper flow of the code. I have done so by first suggesting a structure of my own and then asked Gemini to point weaker areas and suggest improvements. 
- **Consulting code correctness** — I have asked AI to evaluate every predicate I wrote and suggest improvements to achieve the best Prolog practices. 
- **Generating documentation structure** — I have used AI to generate a structure for the user and developer documentation that I have then filled out with text of my own. 

To summarize, I have not used AI to generate the initial code itself, but it played crucial role in refactorization and the structuring part of this project.